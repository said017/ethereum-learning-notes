# 14-GateKeeperTwo

1. There are three modifier that we need to pass, let's examine one by one

2. First Modifier, relatively simple because we have faced this before, we have to call this function via a contract so `msg.sender` and `tx.origin` will be different :

```solidity
   modifier gateOne() {
        require(msg.sender != tx.origin);
        _;
    }
```

3. Second Modifier, to pass Gate 2’s, we have to somehow pass code size check equal to 0, but we call this via a contract which will result in > 0. One way to make this contract code size 0 is via `selfdesctruct` but calling it in a function will not call any line of code after that. We have to call the function inside `constructor` since in this initialization stage, the code size is not currently there.

```solidity
    constructor(address _gateAddress) {
        gateKeeper = GatekeeperTwo(_gateAddress);
        bytes8 _key = ~bytes8(keccak256(abi.encodePacked(address(this))));
        gateKeeper.enter(_key);
    }
```

4. Third Modifier, we need to understand how data convertions and bitwise operator, to make value equal to `type(uint64).max` we need to fill every bit with `1` value. XOR bitwise will equal to `1` if two operator value is `1` and `0` or `0` and `1`. We can get that by doing this :

```solidity
    bytes8 _key = ~bytes8(keccak256(abi.encodePacked(address(this))));
```

BITWISE NOT result of `bytes8(keccak256(abi.encodePacked(address(this))))` XOR with itself will result all bit equal to `1` or `type(uint64).max`.
