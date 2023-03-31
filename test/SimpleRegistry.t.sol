// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "../src/SimpleRegistry.sol";

contract SimpleRegistryTest is Test {
    SimpleRegistry public registry;

    event Registered(address indexed owner, string name);
    event Released(address indexed owner, string name);

    function setUp() public {
        registry = new SimpleRegistry();
    }

    function testRegister() public {
        vm.prank(msg.sender);
        vm.expectEmit(true, false, false, true);
        emit Registered(msg.sender, "test");

        registry.register("test");
        assertEq(registry.registry("test"), msg.sender);
    }

    function testCannotRegisterOccupiedName() public {
        registry.register("test");
        vm.expectRevert(bytes("Name already registered"));
        registry.register("test");
    }

    function testRelease() public {
        vm.startPrank(msg.sender);
        vm.expectEmit(true, false, false, true);
        emit Released(msg.sender, "test");

        registry.register("test");
        registry.release("test");
        assertEq(registry.registry("test"), address(0));
    }

    function testNotNameOwner() public {
        registry.register("test");
        vm.prank(msg.sender);
        vm.expectRevert(bytes("You don't own this name"));
        registry.release("test");
    }
}
