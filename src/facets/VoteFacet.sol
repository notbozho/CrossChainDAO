// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import { LibVote } from "src/libraries/LibVote.sol";

contract VoteFacet {
    function vote(uint256 proposalId, bool positive) external {
        LibVote.vote(proposalId, positive);
    }
}
