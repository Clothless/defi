// SPDX-License-Identifier: UNKNOWN 
pragma solidity ^0.5.16;

import "./DappToken.sol";
import "./DaiToken.sol";

contract TokenFarm {
    string public name = "Dapp Token Farm";
    address public owner;
    DaiToken public daiToken;
    DappToken public dappToken;

    address[] public stakers;
    mapping(address => uint) public stakingBalance;
    mapping(address => bool) public hasStaked;
    mapping(address => bool) public isStaking;

    constructor(DappToken _dappToken, DaiToken _daiToken) public {
        dappToken = _dappToken;
        daiToken = _daiToken;
        owner = msg.sender;
    }

    // Staking (deposit) Tokens
    function stakeTokens(uint _amount) public {
        // Transfer Mock Dai tokens to this contract for staking
        daiToken.transferFrom(msg.sender, address(this), _amount);

        // Update staking balance
        stakingBalance[msg.sender] = stakingBalance[msg.sender] + _amount;

        // Save users address who have staked, it's just a list of addresses
        // like saving a trace
        // Add user to stakers array *only* if they haven't staked already
        // This is to prevent duplicate entries in the stakers array
        if(!hasStaked[msg.sender]) {
            stakers.push(msg.sender);
        }

        // Update staking status
        isStaking[msg.sender] = true;

        //
        // This is changing whenever a user stakes
        // Like whenever a user calls this function
        hasStaked[msg.sender] = true;
    }

    // Unstaking (withdraw) Tokens
    function unstakeTokens() public {
        // Get the staking balance of the user
        uint balance = stakingBalance[msg.sender];
        // We need to check that the balance is positive
        // You can't transfer back 0 tokens
        require(balance > 0, "staking balance cannot be 0");

        // Transfer Mock Dai tokens to this contract for staking
        // Giving back the staked amount to the user
        daiToken.transfer(msg.sender, balance);

        // Reset staking balance
        // now we need to make sure to change the balance status
        // and set the user balance to 0
        // cuz we transfered back all of his staked tokens
        stakingBalance[msg.sender] = 0;

        // Update staking status
        isStaking[msg.sender] = false;
    }

    // Issue Tokens
    function issueTokens() public {
        // This is a public function, so anyone can call it
        // but we want to restrict it only to the owner of the contract
        require(msg.sender == owner, "Only owner can call this function");

        // Issue tokens to all stakers
        for (uint i=0; i<stakers.length; i++) {
            // Get the address of the staker
            address recipient = stakers[i];
            // Get the balance of the staker
            uint balance = stakingBalance[recipient];
            if(balance > 0) {
                // Just give the staker the same amount of Dapp tokens
                // Like if you deposit 100 DAI, you get 100 Dapp tokens
                // easy peasy lemon squeezy
                dappToken.transfer(recipient, balance);
            }
        }
    }
}