# 01-Fallback Solutions

The Fallback have `owner` state that iniitialize in `constructor` along with `contributions` mapping of the current `owner` with 1000 ETH value.

The goal is to set `owner` to our address and drain contract balance using `withdraw` function.

Problems : 1. To change the owner using available function `contribute`, we have to send 1000 ETH, to much. 2. `withdraw` function have `onlyOwner` modifier.

Vulnerabilities : there is `receive` function defined, containing condition where we could claim `owner` without sending 1000 ETH

Solutions :

1. `receive` function require us to have `contribution` > 0, so we call `contribute` function with very low `msg.value` but greater than 0.

```shell
contract.contribute({value: 100000000000000})
```

2. `receive` function triggered when we send ETH to the contract trough native call/send. We already fulfilled the `contribution` > 0 check, just need to send direct ETH to the contract with `msg.value` > 0.

```shell
contract.sendTransaction({value: 10000000000000})
```

3. Then you can check, `owner` should already change to your address

```shell
await contract.owner()
```

4. Finally, drain the contract by call `withdraw` function :

```shell
contract.withdraw()
```
