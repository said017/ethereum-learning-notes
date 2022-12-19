# 10-Reentrancy

1. Reentrancy happened because of abusing `receive` and `fallback` function, to reenter function call until draining all the funds.

2. The solution provided in `ReentrancyAttack.sol`
