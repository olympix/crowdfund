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
    
    function setUp() public {

        projectFactory = new ProjectFactory();
        creator = address(0x1);
        donater = address(0x3);

        vm.deal(donater, 150 ether);

        vm.startPrank(creator);
        project = Project(projectFactory.create(100 ether, "Test", "TST"));
        vm.stopPrank();

    }

    function testFailAchieveGoal() public {

        vm.startPrank(donater);
        project.contribute{value: 100 ether}();
        
    } 

    function testSomeOtherExploit() public {

    }


}