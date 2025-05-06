// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {
    LibAppStorage,
    AppStorage,
    Proposal,
    ProposalState
} from "src/libraries/LibAppStorage.sol";
import { LibDiamond } from "src/libraries/LibDiamond.sol";
import { LibProposal } from "src/libraries/LibProposal.sol";
import { Errors } from "src/libraries/Errors.sol";
import { Events } from "src/libraries/Events.sol";
import { Constants } from "src/libraries/Constants.sol";

library LibProposalExecution {
    function executeProposal(uint256 proposalId) internal {
        AppStorage storage s = LibAppStorage.appStorage();
        Proposal storage p = s.proposals[proposalId];
        require(
            LibProposal.proposalState(s, proposalId) == ProposalState.Succeeded,
            Errors.ProposalMustBeSucceeded()
        ); // TODO: change this to Queued

        // CEI pattern
        p.executed = true;

        _queueTransactions(s, p, proposalId);

        emit Events.ProposalExecuted(proposalId, msg.sender);
    }

    function cancelTransaction(
        uint256 proposalId,
        address target,
        uint256 value,
        bytes calldata data,
        uint256 deadline,
        uint256 chainId
    ) internal {
        address owner = LibDiamond.contractOwner();
        require(msg.sender == owner, Errors.NotOwner());

        AppStorage storage s = LibAppStorage.appStorage();

        bytes32 txHash = keccak256(
            abi.encode(proposalId, target, value, data, deadline, chainId)
        );

        require(
            s.queuedTransactions[txHash], Errors.TransactionNotQueued(txHash)
        );

        delete s.queuedTransactions[txHash];

        emit Events.TransactionCanceled(
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
    ) internal {
        AppStorage storage s = LibAppStorage.appStorage();

        bytes32 txHash = keccak256(
            abi.encode(proposalId, target, value, data, deadline, chainId)
        );

        require(
            s.queuedTransactions[txHash], Errors.TransactionNotQueued(txHash)
        );
        require(
            deadline >= block.timestamp,
            Errors.TransactionExpired(txHash, deadline)
        );

        (bool success, bytes memory returnData) =
            payable(target).call{ value: value }(data);

        if (success) {
            delete s.queuedTransactions[txHash];
            emit Events.TransactionSucceeded(
                proposalId, target, value, data, deadline, returnData, chainId
            );
        } else {
            string memory errorMessage = _getErrorMessage(returnData);
            emit Events.TransactionReverted(
                proposalId, target, value, data, deadline, errorMessage, chainId
            );
        }
    }

    // Wrong inputs should revert, Out-of-gas reverts related to too many inputs are counted as user error
    function executeTransactionsBulk(
        uint256[] calldata proposalIds,
        address[] calldata targets,
        uint256[] calldata values,
        bytes[] calldata datas,
        uint256[] calldata deadlines,
        uint256 chainId
    ) internal {
        AppStorage storage s = LibAppStorage.appStorage();

        uint256 length = targets.length;
        for (uint256 i; i < length;) {
            // TODO: just use the single executeTransaction
            uint256 proposalId = proposalIds[i];
            address target = targets[i];
            uint256 value = values[i];
            bytes calldata data = datas[i];
            uint256 deadline = deadlines[i];

            bytes32 txHash = keccak256(
                abi.encode(proposalId, target, value, data, deadline, chainId)
            );

            require(
                s.queuedTransactions[txHash],
                Errors.TransactionNotQueued(txHash)
            );
            require(
                deadline >= block.timestamp,
                Errors.TransactionExpired(txHash, deadline)
            );

            (bool success, bytes memory returnData) =
                payable(target).call{ value: value }(data);

            if (success) {
                delete s.queuedTransactions[txHash];
                emit Events.TransactionSucceeded(
                    proposalId,
                    target,
                    value,
                    data,
                    deadline,
                    returnData,
                    chainId
                );
            } else {
                string memory errorMessage = _getErrorMessage(returnData);
                emit Events.TransactionReverted(
                    proposalId,
                    target,
                    value,
                    data,
                    deadline,
                    errorMessage,
                    chainId
                );
            }

            unchecked {
                ++i;
            }
        }
    }

    function _queueTransactions(
        AppStorage storage s,
        Proposal storage p,
        uint256 proposalId
    ) internal {
        uint256 txLength = p.targets.length;
        for (uint256 i; i < txLength;) {
            address target = p.targets[i];
            uint256 value = p.values[i];
            bytes memory data = p.datas[i];
            uint256 deadline =
                block.timestamp + Constants.TRANSACTION_EXECUTION_PERIOD;
            uint256 chainId = p.chainId;

            bytes32 txHash = keccak256(
                abi.encode(proposalId, target, value, data, deadline, chainId)
            );

            s.queuedTransactions[txHash] = true;

            emit Events.TransactionQueued(
                proposalId, target, value, data, deadline, chainId
            );

            unchecked {
                ++i;
            }
        }
    }

    // function _sendExecute(Proposal storage p) internal {

    // }

    function _getErrorMessage(bytes memory returnData)
        internal
        pure
        returns (string memory)
    {
        if (returnData.length < 68) return "Silent revert";

        assembly {
            returnData := add(returnData, 0x04) // skip function selector
        }

        return abi.decode(returnData, (string));
    }
}
