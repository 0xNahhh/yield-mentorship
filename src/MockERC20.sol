// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import {ERC20} from "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

contract MockERC20 is ERC20 {
    // @notice constructor to setup ERC20 token
    constructor() ERC20("Asd", "ASD") {}

    // @notice mints amount of tokens to the recpient assigned to the to address
    // @param to the recipient recieving the amount of tokens
    // @param the amount of tokens to mint
    function mint(address to, uint256 amount) external {
        _mint(to, amount);
    }
}
