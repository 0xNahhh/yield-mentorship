// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import {MockERC20} from "../src/MockERC20.sol";
import {BasicVault} from "../src/BasicVault.sol";

contract BasicVaultScript is Script {
    function setUp() public {}

    function run() public {
        uint256 signer = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(signer);

        MockERC20 mockERC20 = new MockERC20();
        BasicVault basicVault = new BasicVault(address(mockERC20));

        vm.stopBroadcast();
    }
}
