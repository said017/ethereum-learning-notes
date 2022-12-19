# 08-Vault

1. `private` modifier does'nt mean your state can't be read by other people. Anyone can read your data by looking at storage data location in your contract.

2. Use any library, such as `web3` and call `web3.eth.getStorageAt(<contract address>, <location index>)` where location index can be figured out by looking at state definition order in contract, index pointing at storage slot, where per slot size is 32 bytes, where data with total < 32 bytes like `boolean` can be fit into 1 slot.

3. This will return data in hex format, since 32 bytes is take 1 full slot, and defined after the `bool`, it will take the next slot, in this case at index 1.

4. The password is "A very strong secret password :)"
