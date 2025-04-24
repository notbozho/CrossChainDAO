// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import { LibProposal } from "src/libraries/LibProposal.sol";

contract ProposalsFacet {
    function createProposal(
        string memory description,
        uint256 startBlock,
        uint256 duration,
        address[] calldata targets,
        uint256[] calldata values,
        bytes[] calldata calldatas,
        uint256 chainId
    ) external {
        LibProposal.createProposal(
            description,
            startBlock,
            duration,
            targets,
            values,
            calldatas,
            chainId
        );
    }
}
