// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {
    LibAppStorage,
    AppStorage,
    Proposal,
    ProposalState,
    Receipt
} from "src/libraries/LibAppStorage.sol";
import { LibDiamond } from "src/libraries/LibDiamond.sol";
import { Errors } from "src/libraries/Errors.sol";
import { Constants } from "src/libraries/Constants.sol";

import { ERC20Votes } from
    "@openzeppelin/contracts/token/ERC20/extensions/ERC20Votes.sol";

library LibProposal {
    function createProposal(
        string memory description,
        uint256 startBlock,
        uint256 duration,
        address[] calldata targets,
        uint256[] calldata values,
        bytes[] calldata datas,
        uint256 chainId
    ) internal returns (uint256 proposalId) {
        require(
            duration >= Constants.MIN_PROPOSAL_DURATION
                && duration <= Constants.MAX_PROPOSAL_DURATION,
            Errors.InvalidParameter("duration")
        );
        _validateTransactions(targets, values, datas);

        AppStorage storage s = LibAppStorage.appStorage();

        proposalId = s.totalProposals++;

        uint256 start = startBlock == 0 ? block.number : startBlock;

        s.proposals[proposalId] = Proposal({
            proposer: msg.sender,
            description: description,
            startBlock: start,
            endBlock: start + duration,
            submitBlock: block.number,
            forVotes: 0,
            againstVotes: 0,
            quorumBps: s.currentQuorumBps,
            executed: false,
            canceled: false,
            targets: targets,
            values: values,
            datas: datas,
            chainId: chainId
        });
    }

    function cancelProposal(uint256 proposalId) internal {
        AppStorage storage s = LibAppStorage.appStorage();
        ProposalState state = proposalState(s, proposalId);

        Proposal storage p = s.proposals[proposalId];
        address owner = LibDiamond.contractOwner();
        require(
            msg.sender == p.proposer || msg.sender == owner,
            Errors.NotProposer()
        );

        if (
            state == ProposalState.Canceled || state == ProposalState.Defeated
                || state == ProposalState.Executed
                || state == ProposalState.Succeeded
        ) {
            revert Errors.CantCancelAtThisState();
        }

        p.canceled = true;
    }

    function proposalState(AppStorage storage s, uint256 proposalId)
        internal
        view
        returns (ProposalState)
    {
        require(
            s.totalProposals >= proposalId,
            Errors.InvalidParameter("proposalId")
        );
        Proposal storage p = s.proposals[proposalId];

        if (p.canceled) {
            return ProposalState.Canceled;
        } else if (block.number <= p.startBlock) {
            return ProposalState.Pending;
        } else if (block.number <= p.endBlock) {
            return ProposalState.Active;
        } else if (isDefeated(s, p)) {
            return ProposalState.Defeated;
        } else if (p.executed) {
            return ProposalState.Executed;
            // check for State.Expired
        } else if (block.number > p.endBlock) {
            // TODO: fix this
            return ProposalState.Succeeded;
        } else {
            return ProposalState.Queued;
        }
    }

    function isDefeated(AppStorage storage s, Proposal storage p)
        internal
        view
        returns (bool)
    {
        uint256 forVotes = p.forVotes;
        return forVotes <= p.againstVotes || forVotes < minimumVotes(s, p);
    }

    /// @notice get minimum FOR votes required to reach quorum
    function minimumVotes(AppStorage storage s, Proposal storage p)
        internal
        view
        returns (uint256)
    {
        ERC20Votes daoToken = s.daoToken;

        uint256 pastTotalSupply = daoToken.getPastTotalSupply(p.submitBlock);

        return pastTotalSupply * p.quorumBps / Constants.BPS_DENOMINATOR;
    }

    function _validateTransactions(
        address[] calldata targets,
        uint256[] calldata values,
        bytes[] calldata datas
    ) internal pure {
        require(targets.length != 0, Errors.InvalidParameter("targets"));
        require(
            targets.length == values.length && values.length == datas.length,
            Errors.InvalidParameter("targets, values, datas length mismatch")
        );
        require(
            targets.length <= Constants.MAX_TRANSACTIONS,
            Errors.InvalidParameter("transactions count > MAX_TRANSACTIONS")
        );
    }
}
