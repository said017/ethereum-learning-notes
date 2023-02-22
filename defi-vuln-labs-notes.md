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

## Bypasscontract

- isContract check in a function should not rely on code size of the caller, since if the contract called inside constructor of the attacker contract, the returned size is still zero
- combine it with using `tx.origin==msg.sender`

## DOS

- Contract external calls can fail deliberately by malicious contract that designed to not accept any ether, this could lead to DOS if state of the system rely on the call need to be success.
- Mitigated by using separate function to call the withdraw and altering game/system state.

## Randomness

- using `block.number` and `block.timestamp` for random source is not reliable since any call in the same block will reproduce the same number.
- Use reliable oracle for source of randomness

## Visibility

- This may seems like a stupid mistake, but not setting up proper visibility caused some project a lot of money
- Always check multiple times to make sure every function have proper visibility

## TXOrigin

- Never use `tx.origin` for caller verification, since it is very susceptible to phishing attack. user can be tricked to call a contract that lead to call another critical function that could lead to lost of funds.
- Use `msg.sender` instead.

## Uninitialized Contract Variables

- This can commonly seen on UUPS implementation, local storage variables are not initialized could causing unintended or malicious behaviors.

## Storage Collision

- Again, happened usually on upgradable contract, unmatched storage slot between proxy and implementation could lead to unintended behavior.

## Approval Scam

- Be wary of any website asking for token approval, it could lead to lost of funds

## Signature Replay

- If not protected signature of the same transaction can be used again for others

## Data Location - Storage vs Memory

- Referencing data using incorrect data location could lead to unintended behavior. If want to persist, use `storage`.

![image](https://user-images.githubusercontent.com/19762585/220502872-10f04cc7-ce3e-42e3-b409-69c538541026.png)

## Dirty Bytes

- copying `bytes`arrays from memory or calldata to storage may result in dirty storage values.

## Invariants

- Assert is used to check invariants. Those are states our contract or variables should never reach, ever. For example, if we decrease a value then it should never get bigger, only smaller.

## NFT Mint Exposed Metadata

- Exposed metadata during minting could lead to attacker can find out valuable NFTs and then target mint of specific NFTs by monitoring mempool and sell the NFTs for a profit in secondary market

## Divmultiply

- Solidity doesn’t have decimal precision, so it is generally better to do multiplication before division to avoid unintended rounding.

## Unchecked Return Value

- Some token like (USDT) doesn’t implement ERC20 standard, and behave differently like not returning void instead of value if transfer is successful. Calling these functions with the correct EIP20 function signatures will always revert.
