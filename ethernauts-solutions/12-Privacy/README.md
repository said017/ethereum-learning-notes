# 12-Privacy

1. `private` type does'nt mean your state can't be read by other people. Anyone can read your data by looking at storage data location in your contract.

2. Use any library, such as `web3` and call `web3.eth.getStorageAt(<contract address>, <location index>)` where location index can be figured out by looking at state definition order in contract, index pointing at storage slot, where per slot size is 32 bytes, where data with total < 32 bytes like `boolean` and `uint8` can be fit into 1 slot.

3. This will return data in hex format, since 32 bytes is take 1 full slot, storage filled with `bool public locked` at slot 1, ` uint256 public ID` at slot 2, `uint8 private flattening` with ` uint8 private denomination` and ` uint16 private awkwardness` at slot 3, `bytes32[3] private data` at slot 4 5 6 consecutively. and `data[2]` at slot 6, at index 5.

4. `await web3.eth.getStorageAt("0xd533a94194d7DcdD6fAa5b426e97d701ec5A7Ea7", 5)` will return `bytes32`

5. When you convert this to bytes16, solidity will remove the 16 bytes (or 32 digits in hexadecimal) from the right. When bytesX is converted to bytesY where y < x then x is truncated from the right hand side till the length in bytes is equal to y.

6. resulting `bytes16` `_key` is "0x48f9eabfc45106012bae40ff2c23104f" in this case.
