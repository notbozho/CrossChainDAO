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

    // transactions
    event TransactionQueued(
        uint256 indexed proposalId,
        address indexed target,
        uint256 value,
        bytes data,
        uint256 deadline,
        uint256 indexed chainId
    );
    event TransactionSucceeded(
        uint256 indexed proposalId,
        address indexed target,
        uint256 value,
        bytes data,
        uint256 deadline,
        bytes returnData,
        uint256 indexed chainId
    );
    event TransactionReverted(
        uint256 indexed proposalId,
        address indexed target,
        uint256 value,
        bytes data,
        uint256 deadline,
        string errorMessage,
        uint256 indexed chainId
    );

    event TransactionCanceled(
        uint256 indexed proposalId,
        address indexed target,
        uint256 value,
        bytes data,
        uint256 deadline,
        uint256 indexed chainId
    );

    event Voted(
        uint256 indexed proposalId,
        address indexed user,
        uint256 votes,
        bool positive
    );
}
