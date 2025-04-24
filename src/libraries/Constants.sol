// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

library Constants {
    uint256 constant BPS_DENOMINATOR = 10_000; // 100%
    uint256 constant MAX_QUORUM_BPS = 10_000; // 100%
    uint256 constant MIN_QUORUM_BPS = 3_000; // 30%

    uint256 constant MIN_PROPOSAL_DURATION = 7200; // 1 day in blocks (12s/block https://goto.etherscan.com/chart/blocktime)
    uint256 constant MAX_PROPOSAL_DURATION = 216_000; // 30 days in blocks
}
