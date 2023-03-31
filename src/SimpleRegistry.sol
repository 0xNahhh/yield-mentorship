// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import "forge-std/console.sol";

contract SimpleRegistry {
    mapping(string => address) public registry;

    event Registered(address indexed owner, string name);
    event Released(address indexed owner, string name);

    function register(string calldata name) external {
        console.log("registry name address: ", registry[name]);
        require(registry[name] == address(0), "Name already registered");
        registry[name] = msg.sender;

        emit Registered(msg.sender, name);
    }

    function release(string calldata name) external {
        require(registry[name] == msg.sender, "You don't own this name");
        delete registry[name];

        emit Released(msg.sender, name);
    }
}
