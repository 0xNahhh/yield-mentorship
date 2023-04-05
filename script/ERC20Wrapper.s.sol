// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import {ERC20Wrapper} from "../src/ERC20Wrapper.sol";
import {MockERC20} from "../src/MockERC20.sol";

contract ERC20WrapperScript is Script {
    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        // initialize contracts here
        MockERC20 token = new MockERC20();
        ERC20Wrapper wrapper = new ERC20Wrapper(address(token), "wrapper", "WRAP");

        vm.stopBroadcast();
    }
}
