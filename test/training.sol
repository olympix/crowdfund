// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "src/CrowdFunder.sol";
import "src/Project.sol";

contract CrowdFunderTest is Test {

    address alice = address(0x456);
    address bob = address(0x789);
    address charlie = address(0xabc);
    address david = address(0xdef);
    address eve = address(0xff);
    address fred = address(0xaaa);
    address greg = address(0xbbb);
    address harry = address(0xccc);
    address isable = address(0xddd);
    address james = address(0xeee);   
    

    function testMint() public {
        vm.startPrank(alice);
        CrowdFunder crowdFunder = new CrowdFunder('CrowdFunder', 'CRF');
        crowdFunder.mint(bob);
        vm.stopPrank();
    }

    function testContributeSucess() public {
        
        vm.startPrank(bob);
        Project project = new Project(50 ether, 'Project', 'PJT', bob);
        vm.stopPrank();

        vm.deal(alice, 100 ether);

        vm.startPrank(alice);
        project.contribute{value: 10 ether}();
        vm.stopPrank();
    
    }

    function testContributeGoalFailed() public {
        vm.startPrank(bob);
        Project project = new Project(50 ether, 'Project', 'PJT', bob);
        vm.stopPrank();

        vm.deal(alice, 100 ether);
        vm.warp(block.timestamp + 31 days);
        
        vm.startPrank(alice);
        vm.expectRevert('Goal already achieved or failed');
        project.contribute{value: 10 ether}();
        vm.stopPrank(); 
    }

    function testClaimTokensSuccess() public {
        vm.startPrank(bob);
        Project project = new Project(50 ether, 'Project', 'PJT', bob);
        vm.stopPrank();

        vm.deal(alice, 100 ether);

        vm.startPrank(alice);
        project.contribute{value: 10 ether}();
        project.claimTokens();
        vm.stopPrank();
    }

    function testRefundSucess() public {
        vm.startPrank(bob);
        Project project = new Project(50 ether, 'Project', 'PJT', bob);
        vm.stopPrank();

        vm.deal(alice, 100 ether);
        
        vm.startPrank(alice);
        project.contribute{value: 10 ether}();
        vm.stopPrank(); 

        vm.warp(block.timestamp + 31 days);

        vm.startPrank(alice);
        project.refund();
        vm.stopPrank(); 
    }

    function testWithdrawSuccess() public {
        vm.startPrank(bob);
        Project project = new Project(50 ether, 'Project', 'PJT', bob);
        vm.stopPrank();

        vm.deal(alice, 100 ether);
        
        vm.startPrank(alice);
        project.contribute{value: 50 ether}();
        vm.stopPrank(); 

        vm.startPrank(bob);
        project.withdraw(30 ether);
        vm.stopPrank();  
    }
}