# 07-Force

1. Contract without implementing `receive()` function or any `payable` in one of their function can't receive any ETH except using `selfdescrut` from another contract and put the target contract `payable` address as parameter.

2. There are a few ways to do that, `ForceAttack.sol` is my solution to this problem.
