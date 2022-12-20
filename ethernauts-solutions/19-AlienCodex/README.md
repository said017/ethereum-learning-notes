# 19-AlienCodex

1. To pass this challenge, we have to understand few concepts:
   - Layout storage in general : https://docs.soliditylang.org/en/v0.8.17/internals/layout_in_storage.html
   - Layout storage for inheritance => start from all inheritance contract from left to right, and finally the actual contract.
   - Layout storage for dynamic array => Assume the storage location of the mapping or array ends up being a slot p after applying the storage layout rules. Array data is located starting at `keccak256(p)` and it is laid out in the same way as statically-sized array data would: One element after the other, potentially sharing storage slots if the elements are not longer than 16 bytes.
2. From those concepts, we can know that `owner` variable inherited from `Ownable` contract located at storage slot 1 (index 0), shared with `contact` boolean value.
3. This contract using old compiler version and not using SafeMath check, and we can reduce the `codex` array length by calling `retract` until it underflow to max value.
4. We know that `p` is 1 for `codex` and `keccak256(p)` can be calculated, in this case is `80084422859880547211683076133703299733277748156566366325829078699459944778998`, this storage slot is used by `codex` to point its first index.
5. Storage slot max in each contract is 2^256, we can set `codex` at index 2^256 - `keccak256(p)` = `35707666377435648211887908874984608119992236509074197713628505308453184860938` and it will point to the same storage slot with `owner` because of overflow.
