# 16-Preservation

1. `delegatecall` is executing logic of target address using current contract address. Thus modifying storage slot and state in current contract while using reference at target address.

2. `uint storedTime` at `LibraryContract` located at storage slot 1, using `delegatecall` in `Preservation` contract is not modifying `storedTime` but instead change `address public timeZone1Library` since it also at storage slot 1 (context still using caller contract). Attacker can add malicious contract address with modified `setTime(uint256)` function that could change `owner` as shown in `LibraryContractAttack.sol`.
