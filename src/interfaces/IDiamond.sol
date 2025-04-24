// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

interface IDiamond {
    enum FacetCutAction {
        Add, // 0
        Replace, // 1
        Remove // 2

    }

    struct FacetCut {
        address facetAddress;
        FacetCutAction action;
        bytes4[] functionSelectors;
    }

    event DiamondCut(FacetCut[] _diamondCut, address _init, bytes _calldata);
}
