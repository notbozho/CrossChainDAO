// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import { Test } from "forge-std/Test.sol";

contract TestUtils is Test {
    bytes32 internal nextUserHash = keccak256(abi.encodePacked("user"));

    function newUser() internal returns (address user) {
        user = address(uint160(uint256(nextUserHash)));
        nextUserHash = keccak256(abi.encodePacked(nextUserHash));
    }

    function newUser(uint256 nativeBalance) internal returns (address user) {
        user = address(uint160(uint256(nextUserHash)));
        nextUserHash = keccak256(abi.encodePacked(nextUserHash));
        vm.deal(user, nativeBalance);
    }

    function newUser(string calldata label) internal returns (address user) {
        user = address(uint160(uint256(nextUserHash)));
        nextUserHash = keccak256(abi.encodePacked(nextUserHash));
        vm.label(user, label);
    }

    function newUser(string calldata label, uint256 nativeBalance)
        internal
        returns (address user)
    {
        user = address(uint160(uint256(nextUserHash)));
        nextUserHash = keccak256(abi.encodePacked(nextUserHash));
        vm.deal(user, nativeBalance);
        vm.label(user, label);
    }
}
