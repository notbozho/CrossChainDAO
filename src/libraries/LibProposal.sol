// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {
    LibAppStorage,
    AppStorage,
    Proposal
} from "src/libraries/LibAppStorage.sol";

library LibProposal {
    function createProposal(
        string memory description,
        uint256 startBlock,
        uint256 duration,
        address[] calldata targets,
        uint256[] calldata values,
        bytes[] calldata calldatas,
        uint256 chainId
    ) internal returns (uint256 proposalId) {
        AppStorage storage s = LibAppStorage.appStorage();

        proposalId = s.totalProposals++;

        uint256 start = startBlock == 0 ? block.number : startBlock;

        s.proposals[proposalId] = Proposal({
            proposer: msg.sender,
            description: description,
            startBlock: start,
            endBlock: start + duration,
            forVotes: 0,
            againstVotes: 0,
            executed: false,
            canceled: false,
            targets: targets,
            values: values,
            calldatas: calldatas,
            chainId: chainId
        });
    }
}
