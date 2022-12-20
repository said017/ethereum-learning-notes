# 12-GateKeeperOne

1. There are three modifier that we need to pass, let's examine one by one

2. First Modifier, relatively simple because we have faced this before, we have to call this function via a contract so `msg.sender` and `tx.origin` will be different :

```solidity
   modifier gateOne() {
        require(msg.sender != tx.origin);
        _;
    }
```

3. Second Modifier, this one is tricky, to pass Gate 2’s `require(msg.gas % 8191 == 0)`, you have to ensure that your remaining gas is an integer multiple of 8191, at the particular moment when `msg.gas % 8191` is executed in the call stack. In this case you can calculate manually (takes time) or just brute force until you pass the calculation.

```solidity
        for (uint256 i = 0; i <= 8191; i++) {
            try gate.enter{gas: 800000 + i}(_key) {
                // console.log("passed with gas ->", 800000 + i);
                break;
            } catch {}
        }
```

4. Third Modifier, we need to understand how data convertions and byte masking work on Solidity, i find this article really helpful https://medium.com/coinmonks/ethernaut-lvl-13-gatekeeper-1-walkthrough-how-to-calculate-smart-contract-gas-consumption-and-eb4b042d3009.

This means that the integer key, when converted into various byte sizes, need to fulfil the following properties:

0x11111111 == 0x1111, which is only possible if the value is masked by 0x0000FFFF
0x1111111100001111 != 0x00001111, which is only possible if you keep the preceding values, with the mask 0xFFFFFFFF0000FFFF
Calculate the key using the0xFFFFFFFF0000FFFF mask:

```solidity
    bytes8 _key = bytes8(uint64(uint160(tx.origin))) & 0xFFFFFFFF0000FFFF;
```
