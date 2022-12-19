# 04-Telephone solutions

1. `tx.origin` not equal to `msg.sender` when we call the contract B function from another contract A. Since `tx.origin` will be the EOA caller and `msg.sender` will be the address of the contract A.

2. Solution available at `Telecall.sol`
