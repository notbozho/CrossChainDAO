// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import { ERC20Votes } from
    "@openzeppelin/contracts/token/ERC20/extensions/ERC20Votes.sol";

import { ProposalMessenger } from "src/messaging/ProposalMessenger.sol";

struct AppStorage {
    ERC20Votes daoToken; // address of the governance token used for voting

    ProposalMessenger proposalMessenger;

    mapping(uint256 => Proposal) proposals; // proposalId => proposal struct
    mapping(uint256 proposalId => mapping(address user => Receipt receipt))
        receipts;
    uint256 totalProposals; // the total number of proposals submitted
    uint256 currentQuorumBps;
    mapping(bytes32 txHash => bool queued) queuedTransactions;
}

enum ProposalState {
    Pending,
    Active,
    Defeated,
    Succeeded,
    Executed,
    Canceled,
    Queued,
    Expired
}

struct Proposal {
    address proposer;
    string description;
    uint256 startBlock;
    uint256 endBlock;
    uint256 submitBlock;
    uint256 forVotes;
    uint256 againstVotes;
    uint256 quorumBps; // minimum FOR votes in order for the proposal to be successful
    bool executed;
    bool canceled;
    address[] targets;
    uint256[] values;
    bytes[] datas;
    uint256 chainId; // can be lowered to uint20
}

struct Receipt {
    bool voted;
    bool positive;
    uint256 votes; // can be lowered to save 1 storage slot
}

library LibAppStorage {
    bytes32 constant APP_STORAGE_POSITION =
        keccak256("diamond.standard.dao.storage");

    function appStorage() internal pure returns (AppStorage storage s) {
        bytes32 position = APP_STORAGE_POSITION;

        assembly {
            s.slot := position
        }
    }
}
