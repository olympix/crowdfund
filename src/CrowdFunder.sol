// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import 'openzeppelin-contracts/token/ERC721/ERC721.sol';
import './Project.sol';


contract CrowdFunder is ERC721 {

    address immutable project;
    uint private _currentTokenId = 0;

    modifier onlyProject () {
        require(msg.sender == address(project), 'Only project can call this function');
        _;
    }

    constructor (string memory name, string memory symbol) ERC721(name, symbol) {
        project = msg.sender;
    }

    function mint (address to) public onlyProject() {
        _safeMint(to, _currentTokenId); /* PLEASE HIT THIS LINE */
        _currentTokenId++;  /* PLEASE HIT THIS LINE */
    }

    function recieve() public payable {
    }
}