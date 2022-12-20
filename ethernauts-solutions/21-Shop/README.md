# 21-Shop

1. `view` function is restriced to only read and return value, but we can abuse `isSold` state change on `Shop` contract, before `isSold` change, we return high value, and after it change we return the low price.

```solidity
    function price() external view returns (uint) {
        if (shop.isSold()) {
            return 10;
        } else {
            return 10000;
        }
    }
```

this could happen because `isSold` change before we assign the new `price` value.

```solidity
    if (_buyer.price() >= price && !isSold) {
      isSold = true;
      price = _buyer.price();
    }
```

note from the site :

Contracts can manipulate data seen by other contracts in any way they want.

It's unsafe to change the state based on external and untrusted contracts logic.
