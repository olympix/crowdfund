// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "./CrowdFunder.sol";
import "forge-std/console.sol";

contract Project {

    address public immutable creator;
    
    uint public immutable goal;
    uint timeCreated = block.timestamp;

    bool public goalFailed = false;
    bool public goalAchieved = false;
    
    CrowdFunder nft;

    mapping (address => uint) public contributions;
    mapping (address => uint) public tokensOwed;
    mapping (address => uint) public tokensClaimed;

    modifier onlyCreator() {
        require(msg.sender == creator, "Only creator can call this function");
        _;
    }

    function setGoalStatus() private {
        if(goalAchieved || goalFailed) {
            return;
        } else if (block.timestamp > timeCreated + 30 days) {
            goalFailed = true;
        } else if (address(this).balance >= goal) {
            goalAchieved = true;
        }
    }

    constructor (uint _goal, string memory _name, string memory _symbol, address _creator) {
        goal = _goal;
        nft = new CrowdFunder(_name, _symbol);
        creator = _creator;
    }

    function contribute () public payable {
        
        
        if (block.timestamp > timeCreated + 30 days) {
            goalFailed = true;
        } 
        
        require(msg.value >= 0.01 ether, "Not enough eth");
        require(!(goalAchieved || goalFailed), "Goal already achieved or failed");
        contributions[msg.sender] += msg.value;

        tokensOwed[msg.sender] = contributions[msg.sender] / 1 ether;

        setGoalStatus();
    }

    function claimTokens () public  {
        setGoalStatus();
        uint numTokensToMint = tokensOwed[msg.sender] - tokensClaimed[msg.sender];
        tokensClaimed[msg.sender] += numTokensToMint;
        for (uint i = 0; i < numTokensToMint; i++) {
            nft.mint(msg.sender);
        }
    }

    function refund () public  {
        setGoalStatus();
        require(contributions[msg.sender] > 0, "No contribution to refund");
        require(goalFailed, "Goal not failed");
        uint refundAmount = contributions[msg.sender];
        contributions[msg.sender] = 0;
        (bool success,) = payable(msg.sender).call{value: refundAmount}("");
        require(success, "Refund failed");
    }  

    function withdraw(uint amount) public onlyCreator() {
        setGoalStatus();
        require(goalAchieved, "Goal not achieved");
        require(amount <= address(this).balance, "Not enough eth");
        (bool success,) = payable(creator).call{value: amount}("");
        require(success, "Withdraw failed");
    }

    receive() external payable {
        contribute();
    }
}