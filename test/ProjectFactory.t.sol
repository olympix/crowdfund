// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "src/ProjectFactory.sol";



contract ProjectFactoryTest is DSTest {
    ProjectFactory factory;
    address owner;
    function setUp() public {
        factory = new ProjectFactory();
        owner = address(this);
    }

    function test_create() public {
        address project = factory.create(100, "Test", "TST");
        assertTrue(project != address(0x0), "Project should not be 0x0");
    }
}
