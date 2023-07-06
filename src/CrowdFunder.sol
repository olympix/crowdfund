// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "openzeppelin-contracts/token/ERC721/ERC721.sol";
import "./Project.sol";


contract CrowdFunder is ERC721 {

    address immutable project;
    uint private _currentTokenId = 0;

    modifier onlyProject () {
        require(msg.sender == address(project), "Only project can call this function");
        _;
    }

    constructor (string memory name, string memory symbol, address _project) ERC721(name, symbol) {
        project = _project;
    }

    function mint (address to) public onlyProject() {
        _safeMint(to, _currentTokenId);
        _currentTokenId++;
    }

}
        






