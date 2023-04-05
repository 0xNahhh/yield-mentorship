// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

// OZ libraries
import {ERC20} from "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

contract MockERC20 is ERC20 {
    constructor() ERC20("Asd", "ASD") {}

    function mint(uint256 amount) external {
        _mint(msg.sender, amount);
    }
}