// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import { LibDiamond } from "../libraries/LibDiamond.sol";

contract OwnershipFacet {
    function transferOwnership(address _newOwner) external {
        LibDiamond.enforceIsContractOwner();
        LibDiamond.startTransferOwnership(_newOwner);
    }

    function acceptOwnership() external {
        LibDiamond.enforceIsPendingOwner();
        LibDiamond.transferContractOwner();
    }

    function owner() external view returns (address owner_) {
        owner_ = LibDiamond.contractOwner();
    }

    function pendingOwner() external view returns (address pendingOwner_) {
        pendingOwner_ = LibDiamond.pendingOwner();
    }
}
