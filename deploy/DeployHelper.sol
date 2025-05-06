// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import { Test, console } from "forge-std/Test.sol";
import { strings } from "solidity-stringutils/strings.sol";
import { OApp } from "@layerzerolabs/oapp-evm/contracts/oapp/OApp.sol";

import { IDiamond } from "src/interfaces/IDiamond.sol";
import { IDiamondLoupe } from "src/interfaces/IDiamondLoupe.sol";

contract DeployHelper is Test {
    using strings for *;

    // diamond proxy utils

    function generateSelectors(string memory _facetName)
        internal
        returns (bytes4[] memory selectors)
    {
        //get string of contract methods
        string[] memory cmd = new string[](5);
        cmd[0] = "forge";
        cmd[1] = "inspect";
        cmd[2] = _facetName;
        cmd[3] = "methods";
        cmd[4] = "--json";

        bytes memory res = vm.ffi(cmd);
        string memory st = string(res);

        // extract function signatures and take first 4 bytes of keccak
        strings.slice memory s = st.toSlice();
        strings.slice memory delim = ":".toSlice();
        strings.slice memory delim2 = ",".toSlice();
        selectors = new bytes4[]((s.count(delim)));
        for (uint256 i = 0; i < selectors.length; i++) {
            s.split('"'.toSlice());
            selectors[i] = bytes4(s.split(delim).until('"'.toSlice()).keccak());
            s.split(delim2);
        }
    }

    // layerzero v2 utils
    function _wireOapps(address[] memory oapps, uint256[] memory forkIds)
        internal
    {
        uint256 size = oapps.length;
        for (uint256 i = 0; i < size; i++) {
            OApp localOApp = OApp(payable(oapps[i]));
            for (uint256 j = 0; j < size; j++) {
                if (i == j) continue;
                vm.selectFork(forkIds[j]);
                OApp remoteOApp = OApp(payable(oapps[j]));
                uint32 remoteEid = (remoteOApp.endpoint()).eid();
                vm.selectFork(forkIds[i]);

                vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
                localOApp.setPeer(
                    remoteEid, bytes32(uint256(uint160(address(remoteOApp))))
                );
                vm.stopBroadcast();
            }
        }
    }
}
