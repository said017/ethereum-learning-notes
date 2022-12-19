# 09-Vault

1. `King.sol` vulnerable to Denial of Service attack, because using `payable(king).transfer(msg.value);` line and require the previous `king` to receive the ETH otherwise it will not be changed.

2. By attacking the contract using contract that does not have `receive` function, the `King.sol` will be stop functioning. To mitigate this, always prefer pull method for withdraw over push.
