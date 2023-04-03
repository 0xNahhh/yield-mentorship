// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import {BasicVault} from "../src/BasicVault.sol";
import {MockERC20} from "../src/MockERC20.sol";

contract InitialState is Test {
    BasicVault public basicVault;
    MockERC20 public mockERC20;
    uint256 public amount = 100;

    event Deposited(address indexed owner, uint256 amount);
    event Withdraw(address indexed owner, uint256 amount);

    address public alice = vm.addr(1);
    address public bob = vm.addr(2);

    function setUp() public {
        mockERC20 = new MockERC20();
        basicVault = new BasicVault(address(mockERC20));
    }
}

contract DepositTest is InitialState {
    function test_deposit() public {
        vm.startPrank(alice);
        mockERC20.mint(alice, amount);
        mockERC20.approve(address(basicVault), amount);

        vm.expectEmit(true, true, true, true);
        emit Deposited(alice, amount);

        basicVault.deposit(amount);
        assertEq(basicVault.balances(alice), amount);
    }

    function test_cannotDeposit() public {
        vm.startPrank(alice);
        mockERC20.mint(alice, amount);
        mockERC20.approve(address(basicVault), amount);

        vm.expectRevert(bytes("Insufficient token balance"));
        basicVault.deposit(amount + 10);
    }
}

contract WithdrawTets is InitialState {
    function test_withdraw() public {
        vm.startPrank(alice);
        mockERC20.mint(alice, amount);
        mockERC20.approve(address(basicVault), amount);
        basicVault.deposit(amount);

        vm.expectEmit(true, true, true, true);
        emit Withdraw(alice, amount);

        basicVault.withdraw(amount);
    }

    function test_cannotWithdraw() public {
        vm.startPrank(alice);
        mockERC20.mint(alice, amount);
        mockERC20.approve(address(basicVault), amount);
        basicVault.deposit(amount);

        vm.expectRevert(bytes("Insufficient vault balance"));
        basicVault.withdraw(amount + 10);
    }
}
