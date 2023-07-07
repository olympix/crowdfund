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

    function test_RevertWithdrawNotCreator() public {
        vm.startPrank(bob);
        project.contribute{value: 100 ether}();
        vm.expectRevert('Only creator can call this function');
        project.withdraw(50 ether);
    }

    function test_RevertWithdrawGoalNotAchieved() public {
        vm.startPrank(alice);
        vm.expectRevert('Goal not achieved');
        project.withdraw(50 ether);
    }

    function test_RevertContributeGoalAchieved() public {
        vm.startPrank(alice);
        project.contribute{value: 50 ether}();
        vm.stopPrank();
        vm.startPrank(bob);
        project.contribute{value: 50 ether}();
        vm.expectRevert("Goal already achieved or failed");
        project.contribute{value: 10 ether}();
    }

    function test_RevertContributeGoalFailed() public {
        vm.startPrank(bob);
        project.contribute{value: 10 ether}();
        vm.warp(block.timestamp + 31 days);
        vm.expectRevert('Goal already achieved or failed');
        project.contribute{value: 10 ether}();
    }

    function test_RevertRefundGoalNotFailed() public {
        vm.startPrank(bob);
        project.contribute{value: 10 ether}();
        vm.expectRevert('Goal not failed');
        project.refund();
    }

    function test_RevertRefundNoContribution() public {
        vm.startPrank(bob);
        vm.warp(block.timestamp + 31 days);
        vm.expectRevert('No contribution to refund');
        project.refund();
    }

    function test_RevertContributeNotEnoughEth() public {
        vm.startPrank(bob);
        vm.expectRevert('Not enough eth');
        project.contribute{value: 0.001 ether}();
    }

    function test_RevertRefundFailed() public {
        vm.startPrank(bob);
        RecieveRevert DoubleR = new RecieveRevert();
        DoubleR.contributeToProject{value: 10 ether}(project);
        vm.warp(block.timestamp + 31 days);
        vm.expectRevert('Refund failed');
        DoubleR.refundProject(project);
        
    }

    function test_RevertWithdrawNotEnoughEth() public {
        vm.startPrank(bob);
        project.contribute{value: 100 ether}();
        vm.stopPrank();
        vm.startPrank(alice);
        vm.expectRevert('Not enough eth');
        project.withdraw(100.001 ether);

    }

    function test_RevertWithdrawFailed() public {
        RecieveRevert DoubleR = new RecieveRevert();
        Project proj = DoubleR.createProject();
        
        vm.startPrank(alice);
        DoubleR.contributeToProject{value: 100 ether}(proj);
        vm.stopPrank();

        vm.expectRevert('Withdraw failed');
        DoubleR.withdrawProject(proj, 100 ether);
    }
}

contract RecieveRevert {
    

    function contributeToProject(Project project) public payable {
        project.contribute{value: msg.value}();
    }

    function refundProject(Project project) public {
        project.refund();
    }

    function createProject() public payable returns (Project) {
        return new Project(msg.value, "Project", "PJT", address(this));
    }

    function withdrawProject(Project project, uint256 amount) public {
        project.withdraw(amount);
    }

    receive() external payable {
        revert();
    }
}