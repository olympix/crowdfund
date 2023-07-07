// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "src/Project.sol";

contract ProjectTest is Test {
    Project project;
    address alice;
    address bob;

    function setUp() public {
        alice = address(0x1);
        bob = address(0x2);
        // vm send 100 ether to alice and bob
        vm.deal(alice, 100 ether);
        vm.deal(bob, 100 ether);

        project = new Project(100 ether, "Project", "PJT", alice);
    }

    function test_Contribute() public {
        vm.startPrank(bob);
        project.contribute{value: 10 ether}();
        assertEq(project.contributions(bob), 10 ether);
    }

    function test_ClaimTokens() public {
        vm.startPrank(bob);
        project.contribute{value: 10 ether}();
        project.claimTokens();
        assertEq(project.tokensClaimed(bob), 10);
    }

    function test_Refund() public {
        vm.startPrank(bob);
        project.contribute{value: 10 ether}();
        vm.warp(block.timestamp + 31 days);
        project.refund();
        vm.stopPrank();
        assertEq(project.contributions(bob), 0, "bob should have 0 contribution");
        assertEq(address(project).balance, 0, "project should have 0 balance");
        assertTrue(address(bob).balance == 100 ether, "bob should have 100 ether");
    }

    function test_Withdraw() public {
        vm.startPrank(bob);
        project.contribute{value: 100 ether}();
        vm.stopPrank();
        vm.startPrank(alice);
        project.withdraw(50 ether);
        assertEq(address(project).balance, 50 ether);
    }

    function testFail_WithdrawNotCreator() public {
        vm.startPrank(bob);
        project.contribute{value: 100 ether}();
        project.withdraw(50 ether);
    }

    function testFail_WithdrawGoalNotAchieved() public {
        vm.startPrank(alice);
        project.withdraw(50 ether);
    }

    function testFail_ContributeGoalAchieved() public {
        vm.startPrank(bob);
        project.contribute{value: 100 ether}();
        project.contribute{value: 10 ether}();
    }

    function testFail_ContributeGoalFailed() public {
        vm.startPrank(bob);
        project.contribute{value: 10 ether}();
        vm.warp(block.timestamp + 31 days);
        project.contribute{value: 10 ether}();
    }

    function testFail_RefundGoalNotFailed() public {
        vm.startPrank(bob);
        project.contribute{value: 10 ether}();
        project.refund();
    }

    function testFail_RefundNoContribution() public {
        vm.startPrank(bob);
        vm.warp(block.timestamp + 31 days);
        project.refund();
    }

    function testFail_ContributeNotEnoughEth() public {
        vm.startPrank(bob);
        project.contribute{value: 0.001 ether}();
    }
}