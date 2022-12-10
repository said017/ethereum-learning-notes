# Ethereum Yellowpaper

[https://ethereum.github.io/yellowpaper/paper.pdf](https://ethereum.github.io/yellowpaper/paper.pdf)

## Blockchain Paradigm

Ethereum can be viewed as a transaction-based state machine, beginning with genesis sate and incrementally executes transactions to morph into current state.

A valid state transition is one which comes about trough a transaction. Formally:

```bash
σt+1 ≡ Υ(σt, T)
```

where **Υ** is Ethereum state transition function. In Ethereum, Υ, together with **σ** are considerably more powerful than any existing comparable system **Υ** able to carry out arbitrary computation, while  **σ** allows components to store arbitrary state between transactions.

**Transaction → Bundled into Blocks → Chained together using cryptographic hash = Blockchain**

### Mining

Mining is the process of dedicating effort (working) to bloster one series of transactions (a block) over any other potential competitor block. This scheme is known as a proof-of-work.

Formally, we expand to:

```bash
σt+1 ≡ Π(σt, B)
B ≡ (...,(T0, T1, ...), ...)
Π(σ, B) ≡ Ω(B, Υ(Υ(σ, T0), T1)...)
```

Where **Ω** is the **block-finalization** state transition function (a function that rewards a nominated party); **B** is this block, inside of block includes a series of transactions amongst some other components; and **Π** is the **block-level** state-transition function,

### Protocols

Sometimes, a path follows a new protocol from a particular height (block number). Here are the block numbers of protocol updates on the Ethereum main network:

![Protocols](https://user-images.githubusercontent.com/19762585/205647684-3279c805-0927-40f6-a9b7-c8b535243a3e.png)


, EIP-155 by Buterin [2016b]
introduced the concept of chain ID, which we denote by β.
For the Ethereum main network

```bash
β = 1
```

## Blocks, State and Transactions

### World State

The world state (******state)******, is a mapping between 160-bit addresses and account states (a data structure serialised as RLP).

The account state σ[a], comprises the following four fields:

- **nonce:** A scalar value equal to the number of transactions from this address or, in the case of accounts with associated code, the number of contract-creations made by this account. For account of address a in state σ, this would be formally denoted σ[a]n.
- **balance:** A scalar value equal to the number of Wei owned by this address. Formally denoted σ[a]b.
- **************************storageRoot:************************** A 256-bit hash of the root node of a Merkle Patricia tree that encodes the storage contents of the account (a mapping between 256-bit integer values), encoded into the trie as a mapping from the Keccak 256-bit hash of the 256-bit integer keys to the RLP-encoded 256-bit integer values. The hash is formally denoted σ[a]s.
- **********************codeHash :**********************  The hash of the EVM code of this account—this is the code that gets executed should this address receive a message call. This hash is formally denoted σ[a]c, and thus the code may be denoted as b, given that KEC(b) = σ[a]c.

### Transaction

A transaction (*************formally, T)************* is a single cryptographically-signed instruction constructed by an actor externally to  the scope of Ethereum. The sender of a transaction cannot be a contract.

As of Berlin protocol, there are two transactions types, 0 (legacy) and 1 (EIP-2930). Further, there are two subtypes of transactions: those which result in message calls and those which result in the creation of new accounts with associated code.  All transaction types specify a number
of common fields:

- ************type:************ EIP-2718 transaction type
- **************nonce:************** A scalar value equal to the number of transactions sent by the sender
- ******************gasPrice****************** : A scalar value equal to the number Wei to be paid per gas unit.
- ********************************************************************************gasLimit:******************************************************************************** A scalar value equal to the maximum amount of gas that should be used in executing this transaction. Paid up-front, before any computation is done.
- ********to:******** The 160-bit address of the message call’s recipient or for a contract creation transaction,  ∅, used here to denote the only member of B0 ; formaly Tt.
- **************value:************** A scalar value equal to the number of Wei to be transferred to the message call’s recipient or, in the case of contract creation, as an endowment to the newly created account: formally Tv.
- ********r,s******** : value corresponding to the signature of the transaction and used to determine the sender of the transaction.

EIP-2930 (type 1) transactions also have :

- ************************accessList:************************  List of access entries to warm up; formally TA. Each access list entry E is a tuple of an account address and a list of storage keys: E ≡ (Ea, Es).
- ****************chaindId****************: Chain ID, must be equal to the network chain ID.
- ******************yParity:****************** Signature Y parity; formally Ty.

Additionally, a contract creation transaction contains:

- **********Init:********** An unlimited size byte array specifying the EVM-code for the account initialisation procedure, formally Ti.

In contracst, a message call transaction contains:

- ************data:************ An unlimited size byte array specifying the input data of the message call, formally Ta.

### The Block

The block is collection of relevant piece information, block header, transactions, ommer (a set of transactions and a set of other block headers that are known to have a parent equal to the present block’s parent’s parent. Information in block headers:

- **********************parentHash********************** : The Keccak 256-bit hash of the parent block’s header, in its entirety; formally Hp.
- **********************ommersHash:********************** The Keccak 256-bit hash of the ommers list portion of this block
- **************************beneficiary:************************** The 160-bit address which all fees colelcted from the successful mining of this block transfered
- **********************stateRoot:********************** The Keccak256-bit hash of the root node of the state trie, after all transactions are executed and finalizations applied.
- ********************************transactionsRoot********************************: The Keccak 256-bit hash of the root node of the trie structure populated with each transaction in the transactions list portion of the block.
- ************************receiptsRoot************************: The Keccak 256-bit hash of the root node of the trie structure populated with the receipts of each transaction in the transactions list portion of the block
- ******************logsBloom******************: The Bloom filter composed from indexable information (logger address and log topics) contained in each log entry from the receipt of each transaction in the transactions list.
- ************************difficulty:************************  A scalar value corresponding to the difficulty level of this block.
- ****************number:****************  A scalar value equal to the number of ancestor blocks.
- ******************************************************gasLimit :****************************************************** A scalar value equal to the current limit of gas expenditure per block
- ******************gasUsed:****************** A scalar value equal to the total gas used in transactions in this block
- ********************timestamp:******************** A scalar value equal to the reasonable output of Unix’s time() at this block’s inception
- **********************extraData:********************** An arbitrary byte array containing data relevant to this block.
- **************mixHash**************: A 256-bit hash which, combined with the nonce, proves that sufficient amount of computation has been carried out on this block.
- ******nonce:****** A 64-bit value which, combined with the **mixHash**, proves that a sufficient amount of computation has beeen carried out on this block.

**************************************Transaction Receipt**************************************

The transaction receipt, R, is a tuple of five items comprising: the type of the transaction, Rx, the status code of the transaction, Rz, the cumulative gas used in the block containing the transaction receipt as of immediately after the transaction has happened, Ru, the set of logs created through execution of the transaction, Rl and the Bloom filter composed from information in those logs, Rb.

## Transaction Execution

The execution of a transaction is the most complex part of the Ethereum protocol: it defines the state transition function Υ. It is assumed that any transactions executed first pass the initial tests of intrinsic validity. These include:

1. The transaction is well-formed RLP, with no additional trailing bytes;
2. the transaction signature is valid;
3. the transaction nonce is valid (equivalent to the sender account’s current nonce);
4. the sender account has no contract code deployed (see EIP-3607)
5. the gas limit is no smaller than the intrinsic gas, gn, used by transaction; and
6. the sender account balance contains at least the cost, v0, required in up-front payment.

two types of txns:

- to ≠ 0; message call txn
    - gas cost : 21k + gascost(calldata)
- to = 0; contract creation txn
    - gas cost : 21k + 32k = 53k

`debug_traceTransaction` → JSON

- brownie, hardhat RETURN, REVERT
    - return value
- supported by:
    - supported by:
        - ganache → truffle, brownie
        - hardhat-network → hardhat, …, brownie
        - geth
        - INFURA - even with paid plan not supported
        - `mainnetforking`

## Contract Creation

There are a number of intrinsic parameters used when creating an account: sender (s), original transactor4 (o), available gas (g), gas price (p), endowment (v) together with an arbitrary length byte array, i, the initialisation EVM code, the present depth of the message-call/contractcreation stack (e), the salt for new account’s address (ζ) and finally the permission to make modifications to the state (w). 

STATE VARIABLE INITIALIZABLE = e

CONSTRUCTOR = f

CONTRACT = g

e . f . CODECOPY RETURN . g

### how does a contract get created?

1. you need some `data` / `init` to 0, and that become `code`

disadvantage: cannot have a contstructor

1. you send deployment script, and the `return` value of the script become `code`

always check [ethervm.io](http://ethervm.io) for referencing OPCODE

## Message Call

In the case of executing a message call, several parameters are required: sender (s), transaction originator (o), recipient (r), the account whose code is to be executed (c, usually the same as recipient), available gas (g), value (v) and gas price (p) together with an arbitrary length byte array, d, the input data of the call, the present depth of the message-call/contract-creation stack (e) and finally the permission to make modifications to the state (w).

[https://github.com/runtimeverification/evm-semantics](https://github.com/runtimeverification/evm-semantics)

## Execution Model

The execution model specifies how the system state is altered given a series of bytecode instructions and a small tuple of environmental data. This is specified through a  formal model of a virtual state machine, known as the Ethereum Virtual Machine (EVM). It is a quasi-Turing complete machine; the quasi qualification comes from the fact that the computation is intrinsically bounded through a parameter, gas, which limits the total amount of computation done.

## Appendix G. Fee Schedule

The fee schedule G is a tuple of scalar values corresponding to the relative costs, in gas, of a number of abstract operations that a transaction may effect.

![image](https://user-images.githubusercontent.com/19762585/206855449-bf1233e4-b58c-4968-8f03-5857ab32c0f5.png)

## Appendix H. Virtual Machine Specification

### H.1 Gas Cost

![image](https://user-images.githubusercontent.com/19762585/206855480-be935849-a776-465c-a8f2-05dfafb989d4.png)

### H.2 Instruction Set

**0s: Stop and Arithmetic Operations**

![image](https://user-images.githubusercontent.com/19762585/206855503-093fcbc6-afdb-4886-b0dd-445b0282db7c.png)

**10s: Comparison & Bitwise Logic Operations**

![image](https://user-images.githubusercontent.com/19762585/206855535-0c6d9cb5-8d20-47b7-9296-75b2006be1d1.png)

**20s: KECCAK256**

![image](https://user-images.githubusercontent.com/19762585/206855559-9ab7183d-7a8f-4dd4-aea8-14f0611bfb33.png)

**30s: Environmental Information**

![image](https://user-images.githubusercontent.com/19762585/206855585-8b0e1150-52de-4c31-a5ec-4b159c17866d.png)
![image](https://user-images.githubusercontent.com/19762585/206855601-f29de395-221a-4cb6-92af-74ef08a88287.png)

**40s: Block Information**

![image](https://user-images.githubusercontent.com/19762585/206855622-188c5b11-6955-4124-ab38-3690c53a22f9.png)

**50s: Stack, Memory, Storage and Flow Operations**

![image](https://user-images.githubusercontent.com/19762585/206855648-104d8363-54b2-4238-89ad-51db9e280c6b.png)
![image](https://user-images.githubusercontent.com/19762585/206855668-cda09c04-30b4-4781-ba9d-d7dd65a59932.png)

**60s & 70s: Push Operations**

![image](https://user-images.githubusercontent.com/19762585/206855702-837fe9ae-7df3-477c-a9a9-1aed9fae5431.png)

**80s: Duplication Operations**

![image](https://user-images.githubusercontent.com/19762585/206855718-ecd538ad-4395-4d8b-96b5-6829542fa7b4.png)

**90s: Exchange Operation**

![image](https://user-images.githubusercontent.com/19762585/206855739-9752a1dd-81c3-454d-9dd3-9faa2bdf681e.png)

**a0s: Logging Operations**

![image](https://user-images.githubusercontent.com/19762585/206855781-4cd518c5-a837-49c7-9a2a-46e7de1b79b8.png)

**f0s: System operations**

![image](https://user-images.githubusercontent.com/19762585/206855814-87b05ac7-1a4d-4c2c-9796-0cea42d2d8cf.png)
![image](https://user-images.githubusercontent.com/19762585/206855828-13b1966d-5d13-40b9-b033-f239846efac6.png)












