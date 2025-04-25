// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import { LibProposalExecution } from "src/libraries/LibProposalExecution.sol";

contract ProposalExecutionFacet {
    function executeProposal(uint256 proposalId) external {
        LibProposalExecution.executeProposal(proposalId);
    }

    function cancelTransaction(
        uint256 proposalId,
        address target,
        uint256 value,
        bytes calldata data,
        uint256 deadline,
        uint256 chainId
    ) external {
        LibProposalExecution.cancelTransaction(
            proposalId, target, value, data, deadline, chainId
        );
    }

    function executeTransaction(
        uint256 proposalId,
        address target,
        uint256 value,
        bytes calldata data,
        uint256 deadline,
        uint256 chainId
    ) external {
        LibProposalExecution.executeTransaction(
            proposalId, target, value, data, deadline, chainId
        );
    }

    function executeTransactionsBulk(
        uint256[] calldata proposalIds,
        address[] calldata targets,
        uint256[] calldata values,
        bytes[] calldata datas,
        uint256[] calldata deadlines,
        uint256 chainId
    ) external {
        LibProposalExecution.executeTransactionsBulk(
            proposalIds, targets, values, datas, deadlines, chainId
        );
    }
}
