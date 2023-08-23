// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "src/ProjectFactory.sol";



contract ProjectFactoryTest is Test {
    address alice = address(0x456);


    function testCreate() public {
        vm.startPrank(alice);
        ProjectFactory factory = new ProjectFactory();
        factory.create(100, 'Project', 'PRJ');
        vm.stopPrank();
    }
}
