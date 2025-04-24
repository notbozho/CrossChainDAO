// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

library Errors {
    error InvalidParameter(string param);

    error AlreadyVoted(uint256 proposalId);
    error ProposalNotActive(uint256 proposalId);
    error NotProposer();
    error CantCancelAtThisState();
}
