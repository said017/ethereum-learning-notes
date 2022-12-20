# 17-Preservation

1. Contract addresses are deterministic, you can use the following formula to recalculate the address :

```shell
    address = sha3(rlp_encode(creator_account, creator_account_nonce))[12:]
```

or you can just browse ethscan to search the target contract address
