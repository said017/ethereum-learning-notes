# DeFiVulnLabs

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

## Read-Only Reentrancy

- **ReadOnlyReentrancy.sol,** the advance and recent version of reentrancy attack, call another contract that can manipulate read value result, before actually calling the contract that depend on that read value result.
- Below is ilustration from this [https://www.youtube.com/watch?v=0fgGTRlsDxI](https://www.youtube.com/watch?v=0fgGTRlsDxI) video :

![image](https://user-images.githubusercontent.com/19762585/220131405-9541b54d-958a-4283-8131-f686a36cca87.png)

- But why “get_virtual_price()” is returning different value under this condition? When we call “remove_liquidity”, it burn LP token equal to the amount, then send the calculated ether value to the recipient, but if the recipient is contract, it will trigger its fallback function. **During the execution of the fallback, not all tokens have been sent (balances not fully updated) while the total supply of the LP token has already decreased.**

## ERC777 Callbacks and Reentrancy

- This Reentrancy happened because of the callback implementations available in ERC777 where `ERC777TokensSender` and `ERC777TokensRecipient` will be called if the contract/address implement the callback standard interface.
- Malicious contract addresses may cause reentrancy on such callbacks if reentrancy guards are not used.

## Unchecked and Unsafe External Call

- using arbitrary call is a bad practice, since it can call function from contract and can be malicious.

## Private Data

- `private` doesn't mean the data is not readable or secure.
- anyone can read any data from blockchain by seeing it trough the contract data slot, sensitive data is not recommended to be saved on blockchain.

## Unprotected Callback - NFT \_safeMint

- NFT \_safeMint is not guarantee any safe call, because the function have onERC721Received that can be used to reenter the call if not prevented properly.

## Backdoor Assembly

- Beware of inline assembly call in the smart contract that can change any storage slot to arbitrary value.
