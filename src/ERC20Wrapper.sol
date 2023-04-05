// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

// OZ libraries
import {IERC20} from "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import {ERC20} from "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

// @title ERC20 contract that wraps ERC20 tokens
// @author 0xNahhh
// @notice Users can deposit their ERC20 tokens into this contract in exchange for a wrapped version of the token
contract ERC20Wrapper is ERC20 {
    // state
    IERC20 immutable token;
    mapping(address => uint256) public balance;

    // events
    event Wrap(address indexed owner, uint256 amount);
    event Withdraw(address indexed owner, uint256 amount);

    // errors
    error InsufficientTokenBalance();
    error InsufficientBalance();

    // @notice initializes the ERC20 Wrapper contract
    // @param _token the address of the token to be wrapped
    // @param _name the name of the wrapped token
    // @param _symbol the symbol of the wrapped token
    constructor(address _token, string memory _name, string memory _symbol) ERC20(_name, _symbol) {
        token = IERC20(_token);
    }

    // @notice transfers the amount of ERC20 token into this contract and mints the sender the equivalent amount
    // @param amount the amount of token to be wrapped
    // @dev require the sender to own more than the amount being sent in
    function wrap(uint256 amount) external {
        if (token.balanceOf(msg.sender) < amount) revert InsufficientTokenBalance();
        balance[msg.sender] += amount;

        token.transferFrom(msg.sender, address(this), amount);
        _mint(msg.sender, amount);

        emit Wrap(msg.sender, amount);
    }

    // @notice transfers the token back to the sender and burns the equivalent amount of wrapped token
    // @param amount the amount of token to be returned back to the sender
    // @dev require the sender to own more than the amount being sent in
    function withdraw(uint256 amount) external {
        if (balance[msg.sender] < amount) revert InsufficientBalance();
        balance[msg.sender] -= amount;

        token.transfer(msg.sender, amount);
        _burn(msg.sender, amount);

        emit Withdraw(msg.sender, amount);
    }
}
