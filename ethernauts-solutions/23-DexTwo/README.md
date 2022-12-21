# 23-DexTwo

1. `DexTwo` contract does not limit the pair of ERC20 that can be `swap`. So we can create malicious ERC20, send liquidity to the `DexTwo` address, give `allowance` to it.

2. We can `swap` `token1` and `token2` with this malicious ERC20.

note from the site :

As we've repeatedly seen, interaction between contracts can be a source of unexpected behavior.

Just because a contract claims to implement the ERC20 spec does not mean it's trust worthy.

Some tokens deviate from the ERC20 spec by not returning a boolean value from their transfer methods. See Missing return value bug - At least 130 tokens affected.

Other ERC20 tokens, especially those designed by adversaries could behave more maliciously.

If you design a DEX where anyone could list their own tokens without the permission of a central authority, then the correctness of the DEX could depend on the interaction of the DEX contract and the token contracts being traded.
