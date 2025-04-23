// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

struct AppStorage {
    address daoToken; // address of the governance token used for voting
    mapping(uint256 => Proposal) proposals;
    uint256 totalProposals;
}

enum ProposalState {
    Pending,
    Active,
    Defeated,
    Succeeded,
    Executed,
    Cancelled
}

struct Proposal {
    address proposer;
    string description;
    uint256 startBlock;
    uint256 endBlock;
    uint256 forVotes;
    uint256 againstVotes;
    bool executed;
    bool canceled;
    address[] targets;
    uint256[] values;
    bytes[] calldatas;
    uint256 chainId;
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
