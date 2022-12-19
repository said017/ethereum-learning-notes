# 03-CoinFlip solutions

1. CoinFlip contract require you to guess the output of `flip` function by inputing either `false` or `true`. Then the `flip` function use `block.number-1` to calculate `blockhash` and use it as source of PRNG.

2. The objective is we need to somehow consecutively guess the `flip` output 10 times to pass this problem, tracked by `consecutiveWins` value in public state.

3. Solution : `block.number` is available to all transaction and can be abused by calling `flip` function on another `contract` function, in this case `CoinFlipper` contract have `flipper` function that reconstruct PRNG using `block.number` and call `flip` using the value. Call this 10 times either manually, or using script, but the catch is we have to call it on transaction with differenct `blockhash` each time, so waiting previous `flipper` to finish before call it another call.
