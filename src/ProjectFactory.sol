// SPDX-License-Identifier: UNLICENSED
import './Project.sol';

pragma solidity ^0.8.13;

contract ProjectFactory {

    function create(uint _goal, string memory _name, string memory _symbol) external returns (address) {
        return address(new Project(_goal, _name, _symbol, msg.sender)); /* PLEASE HIT THIS LINE */
    }
}