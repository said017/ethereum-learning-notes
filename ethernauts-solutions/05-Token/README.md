# 05-Token

1. The older solidity compiler does not come with built-in SafeMath checker. So underflow and overflow can easily happened.

```solidity
require(balances[msg.sender] - _value >= 0)
```

the checking of `balances` state can easily abused since if `_value` is higher, the result go underflow and the result become very high uint number.

2. To abuse this contract, you can send any `_value` higher than your current `balances` and send it to any other address.
