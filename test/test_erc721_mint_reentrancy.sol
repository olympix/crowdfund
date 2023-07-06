// SPDX-License-Identifier: UNLICENSED 

/*
pragma solidity ^0.8.19;

import "../src/ProjectFactory.sol";
import "../src/Project.sol";

import "forge-std/console.sol";
import "forge-std/test.sol";
import "openzeppelin/token/ERC721/IERC721Receiver.sol";

contract TestReentrancyMint is Test, IERC721Receiver {

    Project project;
    uint iterations = 0;

    function setUp() public {

        ProjectFactory factory = new ProjectFactory();
        project = Project(factory.create(100 ether, "Test", "TST"));
        vm.deal(address(project), 1 ether);
    }

    function testReentrancy() public { 
        vm.deal(address(this), 1 ether);
        project.contribute{value: 1 ether}();
        project.claimTokens();


    }

    function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data
) external  returns (bytes4) {

        try  project.claimTokens(){

        } catch (bytes memory) {
            return bytes4(0);
        }
    }
}
*/