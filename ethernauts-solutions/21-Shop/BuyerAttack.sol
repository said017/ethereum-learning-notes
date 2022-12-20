// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface Shop {
    function buy() external;

    function isSold() external view returns (bool);
}

contract Buyer {
    Shop shop;

    constructor(address _shopAddress) {
        shop = Shop(_shopAddress);
    }

    function buy() public {
        shop.buy();
    }

    function price() external view returns (uint) {
        if (shop.isSold()) {
            return 10;
        } else {
            return 10000;
        }
    }
}
