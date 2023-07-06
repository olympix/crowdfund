// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "src/Project.sol";


contract ProjectTest is DSTest {
    Project project;
    address owner;
    function setUp() public {
        project = new Project(100 ether, "Test", "TST", address(this));
        owner = address(this);
    }

    function test_contribute() public {
        project.contribute{value: 1 ether}();
        assertTrue(project.contributions(address(this)) == 1 ether, "Contributions should be 1 ether");
    }

    function test_claimTokens() public {
        project.contribute{value: 1.2 ether}();
        project.claimTokens();
        assertTrue(project.tokensOwed(address(this)) == 1 ether / 1 ether, "Tokens owed should be 1");
    }

    

    function onERC721Received(address to, address from, uint tokenId, bytes memory data) pure public returns (bytes4) {
        return bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"));
    }
}