// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

library Events {
    event ProposalSubmitted(
        uint256 proposalId,
        address indexed proposer,
        string description,
        uint256 startBlock,
        uint256 endBlock,
        address[] targets,
        uint256[] values,
        bytes[] calldatas
    );
    event ProposalCanceled(uint256 proposalId);
    event ProposalExecuted(uint256 proposalId, address indexed user);

    event Voted(
        uint256 indexed proposalId,
        address indexed user,
        uint256 votes,
        bool positive
    );
}
