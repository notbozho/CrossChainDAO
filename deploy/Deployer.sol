// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "forge-std/Test.sol";

import { IDiamond } from "src/interfaces/IDiamond.sol";
import { IDiamondCut } from "src/interfaces/IDiamondCut.sol";

import { Diamond } from "src/Diamond.sol";
import { DiamondInit } from "src/DiamondInit.sol";

import { DiamondCutFacet } from "src/facets/DiamondCutFacet.sol";
import { DiamondLoupeFacet } from "src/facets/DiamondLoupeFacet.sol";
import { OwnershipFacet } from "src/facets/OwnershipFacet.sol";
import { ProposalFacet } from "src/facets/ProposalFacet.sol";

import { DeployHelper } from "./DeployHelper.sol";

abstract contract Deployer is Test, DeployHelper {

    address deployerAddress = vm.envAddress("PUBLIC_KEY");

    IDiamond public diamond;
    Diamond public _diamond;
    DiamondCutFacet public _diamondCut;
    DiamondLoupeFacet public _diamondLoupe;

    OwnershipFacet public _ownershipFacet;
    ProposalFacet public _proposalFacet;

    DiamondInit diamondInit = new DiamondInit();

    function deploy() internal returns (address) {
        _diamondCut = new DiamondCutFacet();
        _diamondLoupe = new DiamondLoupeFacet();

        _ownershipFacet = new OwnershipFacet();
        _proposalFacet = new ProposalFacet();

        IDiamondCut.FacetCut[] memory cut = new IDiamondCut.FacetCut[](3);

        vm.label(address(_diamondLoupe), "DiamondLoupeFacet");
        cut[0] = (
            IDiamondCut.FacetCut({
                facetAddress: address(_diamondLoupe),
                action: IDiamondCut.FacetCutAction.Add,
                functionSelectors: generateSelectors("DiamondLoupeFacet")
            })
        );

        vm.label(address(_ownershipFacet), "OwnershipFacet");
        cut[1] = (
            IDiamondCut.FacetCut({
                facetAddress: address(_ownershipFacet),
                action: IDiamondCut.FacetCutAction.Add,
                functionSelectors: generateSelectors("OwnershipFacet")
            })
        );

        vm.label(address(_proposalFacet), "ProposalFacet");
        cut[2] = (
            IDiamondCut.FacetCut({
                facetAddress: address(_proposalFacet),
                action: IDiamondCut.FacetCutAction.Add,
                functionSelectors: generateSelectors("ProposalFacet")
            })
        );


        Diamond d = new Diamond(deployerAddress, address(_diamondCut));
        vm.prank(deployerAddress);
        IDiamondCut(address(d)).diamondCut(cut, address(diamondInit), abi.encodeWithSelector(DiamondInit.init.selector, deployerAddress));

        return address(diamond);
    }
}
