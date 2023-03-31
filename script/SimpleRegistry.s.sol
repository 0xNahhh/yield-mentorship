// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import "forge-std/Script.sol";
import {SimpleRegistry} from "../src/SimpleRegistry.sol";

contract SimpleRegistryScript is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        SimpleRegistry simpleRegistry = new SimpleRegistry();

        vm.stopBroadcast();
    }
}
