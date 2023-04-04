// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import {IERC20} from "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

contract BasicVault {
    IERC20 public immutable token;
    mapping(address => uint256) public balances;

    event Deposited(address indexed owner, uint256 amount);
    event Withdraw(address indexed owner, uint256 amount);

    // @notice Construct a new BasicVault
    // @param _token The address of the token to deposit
    constructor(address _token) {
        token = IERC20(_token);
    }

    // @notice Deposit tokens into the vault
    // @param amount The amount of tokens to deposit
    // @dev this assumes that the user approved this contract to transfer the tokens
    function deposit(uint256 amount) external {
        require(token.balanceOf(msg.sender) >= amount, "Insufficient token balance");
        balances[msg.sender] += amount;
        token.transferFrom(msg.sender, address(this), amount);

        emit Deposited(msg.sender, amount);
    }

    // @notice Withdraw tokens from the vault
    // @param amount The amount of tokens to withdraw
    function withdraw(uint256 amount) external {
        require(balances[msg.sender] >= amount, "Insufficient vault balance");
        balances[msg.sender] -= amount;
        token.transfer(msg.sender, amount);

        emit Withdraw(msg.sender, amount);
    }
}
