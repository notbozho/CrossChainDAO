// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import { LibAppStorage, AppStorage } from "src/libraries/LibAppStorage.sol";
import { DAOToken } from "src/DAOToken.sol";

contract DiamondInit {
    function init(address initialOwner) external {
        AppStorage storage s = LibAppStorage.appStorage();

        s.daoToken = new DAOToken(initialOwner);
    }
}
