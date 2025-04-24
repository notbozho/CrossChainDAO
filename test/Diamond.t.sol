// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import { console } from "forge-std/console.sol";
import { Deployer } from "deploy/Deployer.sol";
import { TestUtils } from "./TestUtils.sol";

contract DiamondTest is Deployer, TestUtils {
    function setUp() public {
        deploy();
    }

    function test_previewOwnerFacet() public {
        console.log("owner is", _ownershipFacet.owner());
    }
}
