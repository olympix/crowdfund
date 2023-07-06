// SPDX-License-Identifier: UNLICENSED 
pragma solidity ^0.8.19;

import "../src/ProjectFactory.sol";
import "../src/Project.sol";

import "forge-std/console.sol";
import "forge-std/test.sol";

contract TestOverContribute is Test {

    Hacker hacker = new Hacker();
    address creator = address(0x2);
    address victim = address(0x3);
    address alice = address(0x4);
    Project project;

    function setUp() public {
        
        vm.deal(creator, 1 ether);
        vm.deal(victim, 200 ether);
        vm.deal(alice, 100 ether);
        vm.deal(address(hacker), 101 ether);

        vm.startPrank(creator);
        ProjectFactory factory = new ProjectFactory();
        project = Project(factory.create(100 ether, "vulnerable", "REENT"));
        vm.stopPrank();
       
    }

    function testOverContribute() public { 
        // Hacker self destructs and gives the project 100 ether (i.e, the goal has been hit)
        hacker.hack(payable(address(project)));
        vm.startPrank(alice);
        project.contribute{value: 100 ether}();
        vm.stopPrank();
        // Project got more than its goal
        assert(address(project).balance > 200 ether); 
    }
}


contract Hacker {
    // The hacker should have a 100 ether.
    function hack(address payable victim) public {
        selfdestruct(victim);
    }
}