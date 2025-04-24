// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {
    LibAppStorage,
    AppStorage,
    Proposal,
    ProposalState,
    Receipt
} from "src/libraries/LibAppStorage.sol";
import { LibProposal } from "src/libraries/LibProposal.sol";
import { Errors } from "src/libraries/Errors.sol";

import { ERC20Votes } from
    "@openzeppelin/contracts/token/ERC20/extensions/ERC20Votes.sol";

library LibVote {
    function vote(uint256 proposalId, bool positive) internal {
        AppStorage storage s = LibAppStorage.appStorage();

        Receipt storage r = s.receipts[proposalId][msg.sender];
        require(!r.voted, Errors.AlreadyVoted(proposalId));

        ProposalState state = LibProposal.proposalState(s, proposalId);
        require(
            state == ProposalState.Active, Errors.ProposalNotActive(proposalId)
        );

        Proposal storage p = s.proposals[proposalId];

        uint256 votes = s.daoToken.getPastVotes(msg.sender, p.submitBlock);

        if (positive) {
            p.forVotes += votes;
        } else {
            p.againstVotes += votes;
        }

        r.voted = true;
        r.positive = positive;
        r.votes = votes;
    }

    function hasVoted(uint256 proposalId, address user)
        internal
        view
        returns (bool voted)
    {
        AppStorage storage s = LibAppStorage.appStorage();

        if (user == address(0)) {
            user = msg.sender;
        }

        voted = s.receipts[proposalId][user].voted;
    }
}
