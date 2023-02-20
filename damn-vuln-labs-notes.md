# DamnVulnLabs

## Integer Overflow

- In solidity version prior to 0.8.x, integer will go automatically roll under or overflow if passing its limit size.
- Must use SafeMath library for solidity version under 0.8.x.
- Most likely not happened to newer project or contracts.
- **Overflow.sol** seems obvious, the timelock can be overflowed by providing very high value.
- But **Overflow2.sol** is more subtle since it seems have overflow checking in public “transfer” and “transferFrom” function, but the actual problem is in “transferFrom” function, the internal call to “\_transfer” is subtracting the balance of msg.sender, instead of the “from” address, thus can be exploited to create underflow condition.

## Selfdestruct

- **Selfdestruct.sol**, malicious attacker can call selfdestruct to their contract, removing all the bytecode and send all ether in that contract to target address (bypassing fallback and receive) and also bypassing normal deposit function that do checking and altering state. Note : never depend on address(this).balance, always put extra state to manage accounting.
- **Selfdestruct2.sol**, have the same problem with selfdestruct.sol, malicious contract send ether to Force.sol, even though it don’t have receive or fallback function.
- One of the oldest form of attack vector, most likely not happened to newer project or contracts

## Delegatecall

- **Delegatecall.sol**, problem is it has implementation contract that let anyone alter the owner of the proxy with using only pwn() function. and second.
- Delegatecall implementation is hard to do right, the storage layout must correct, the upgrade mechanism, the implementation check, access control etc. better to do more research of existing standard before using this on your project.

## Reentrancy

- **Reentrancy.sol,** this is the basic form of reentrancy attack, function that have external interaction but doesn’t do CEI (Checks, Effects, Interactions) most likely would vulnerable to this attack, in this scenario, the “withdrawFunds” function can be called, and when ether is transferred trough “call”, the balances is not updated yet, thus the attacker can call “withdrawFunds” again using contract fallback() payable function to drain until the funds is zero in the contract.
- To mitigate, always use CEI or use lock/noReentranct modifier as provided in example
