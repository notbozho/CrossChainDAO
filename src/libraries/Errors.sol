// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

library Errors {
    error InvalidParameter(string param);
    error NotOwner();

    error AlreadyVoted(uint256 proposalId);
    error ProposalNotActive(uint256 proposalId);
    error NotProposer();
    error CantCancelAtThisState();
    error ProposalMustBeSucceeded();

    // Transactions
    error TransactionQueued(
        bytes32 txHash,
        uint256 proposalId,
        address target,
        uint256 value,
        bytes data,
        uint256 deadline
    );
    error TransactionNotQueued(bytes32 txHash);
    error TransactionExpired(bytes32 txHash, uint256 deadline);
}
