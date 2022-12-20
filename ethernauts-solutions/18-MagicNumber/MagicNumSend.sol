// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./MagicNum.sol";

contract Solver {
    MagicNum magicNum;

    constructor(address _magicNum) {
        magicNum = MagicNum(_magicNum);
    }

    function fortyTwo() external {
        bytes
            memory code = "\x60\x0a\x60\x0c\x60\x00\x39\x60\x0a\x60\x00\xf3\x60\x2a\x60\x80\x52\x60\x20\x60\x80\xf3";
        address solver;

        assembly {
            solver := create(0, add(code, 0x20), mload(code))
        }
        magicNum.setSolver(solver);
    }
}
