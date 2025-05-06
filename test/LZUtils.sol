// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import { TestUtils } from "./TestUtils.sol";
import { TestHelperOz5 } from
    "@layerzerolabs/test-devtools-evm-foundry/contracts/TestHelperOz5.sol";

contract LZUtils is TestHelperOz5, TestUtils {
    function setUp() public {
        super.setUp();
    }
}
