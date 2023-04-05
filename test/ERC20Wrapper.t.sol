// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import {ERC20Wrapper} from "../src/ERC20Wrapper.sol";
import {MockERC20} from "../src/MockERC20.sol";

contract InitialState is Test {
    ERC20Wrapper public wrapper;
    MockERC20 public token;
    uint256 constant amount = 1000;

    event Wrap(address indexed owner, uint256 amount);
    event Withdraw(address indexed owner, uint256 amount);

    address alice = vm.addr(1);

    function setUp() public {
        token = new MockERC20();
        wrapper = new ERC20Wrapper(address(token), "wrapper", "WRAP");
    }
}

contract WrapTest is InitialState {
    function test_wrap() public {
        vm.startPrank(alice);

        token.mint(amount);
        token.approve(address(wrapper), amount);

        vm.expectEmit(true, true, true, true);
        emit Wrap(alice, amount);

        wrapper.wrap(amount);

        assertEq(token.balanceOf(alice), 0);
        assertEq(wrapper.balanceOf(alice), amount);
        assertEq(wrapper.balance(alice), amount);
    }

    function test_CannotWrapNotEnoughFunds() public {
        vm.startPrank(alice);

        token.mint(amount);
        token.approve(address(wrapper), amount);

        vm.expectRevert(ERC20Wrapper.InsufficientTokenBalance.selector);
        wrapper.wrap(amount + 10);
    } 
}

contract WithdrawTest is InitialState {
    function test_withdraw() public {
        vm.startPrank(alice);

        token.mint(amount);
        token.approve(address(wrapper), amount);
        wrapper.wrap(amount);
        wrapper.withdraw(amount);

        assertEq(token.balanceOf(alice), amount);
        assertEq(wrapper.balanceOf(alice), 0);
        assertEq(wrapper.balance(alice), 0);
    }

    function test_CannotWithdrawNotEnoughFunds() public {
        vm.startPrank(alice);

        token.mint(amount);
        token.approve(address(wrapper), amount);
        wrapper.wrap(amount);

        vm.expectRevert(ERC20Wrapper.InsufficientBalance.selector);
        wrapper.withdraw(amount + 10);
    } 
}
