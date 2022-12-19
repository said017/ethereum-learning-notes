# 02-Fallout Solutions

1. This one is tricky, as you may suspect from the compiler version, it is using old `^0.6.0` and still accepting contract name as constructor. But the function that supposed to be constructor misspelled as `Fal1out` with 1 instead of l. Thus leave the function as public and anyone can claim the ownership of this contract.

```shell
contract.Fal1out()
```
