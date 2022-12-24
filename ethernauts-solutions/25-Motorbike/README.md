# 25-Engine Attack

1. To solve this challenge, you have to understand UUPS proxy upgrade pattern, eip1967, and initializable contract

2. We can see that `Engine` has initializable function, that act like constructor for upgradable pattern, but it is called from `Motorbike` context (delegatecall behaviour). So if we can find the `Engine` contract address and call `initialize` directly, it will work.

3. Then we can call `upgradeToAndCall` directly using implementation address and point it to malicious contract that have `selfdestruct`, it will called using `delegatecall` and destroy `Engine` contract.
