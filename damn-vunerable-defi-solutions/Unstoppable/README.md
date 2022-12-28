# Unstoppable

1. The `UnstoppableLender.sol` have strict assertion, that come from different state. while `poolBalance` can be updated using `depositTokens` function. `balanceBefore` can be updated from direct `transfer` from the token contract.

```solidity
   // Ensured by the protocol via the `depositTokens` function
        assert(poolBalance == balanceBefore);
```

2. Sending direct `transfer` to `pool` address will change `balanceBefore` but not `poolBalance`. Then the contract become unusable.
