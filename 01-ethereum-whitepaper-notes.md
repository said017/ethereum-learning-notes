# Learning Ethereum Whitepaper

## **History**

- **1980s and the 1990s**, Anonymous e-cash protocols of the , using cryptographic primitive known as Chaumian blinding, failed because of their reliance on a centralized intermediary.
- ********1998********, WEi Dai’s b-boney, the first proposal to introduce creating money trough solving computational puzzles as well as decentralized consensus, but failed to provide how decentralized consensus is implemented.
- ************2005,************ Hal Finney introduced a concept of “reusable proof of work”, a system which uses ideas from b-money together with Adam Back’s computationally difficult Hashcash puzzles to create a concept of cryptocurrency, failed because of the ideal by relying on trusted computing as a backend.
- ******2009******, a decentralized currency was for the first time implemented in practice by Satoshi Nakamoto, combining established primitives for managing ownership trough public key cryptography with a consensus algorithm for keeping track of who owns coins, known as “proof-of-work”.

## **Background**

Bitcoin in 2009 provide radical development in money and currency, being the first example of successful digital asset which simultaneously has no backing or intrinsic value and no centralized issuer or controller. But arguably more important, the underlying blockchain technology as a toll of distributed consensus. This implementation open up others possibilities from custom currencies and financial instruments ( colored coins ), ownership of an underlying physical device ( smart property ), non-fungible assets, and more complex applications involving having digital assets being directly controlled by a piece of code implementing arbitrary rules (smart contracts) or even DAO.

## **Objective**

“*Ethereum intends to provide a blockchain with a built-in fully fledged Turing-complete programming language that can be used to create “contracts” that can be used to encode arbitrary state transition functions, allowing users to create any of the systems described above, as well as many others that we have not yet imagined, simply by writing up the logic in a few lines of code.*”

## **Key Concepts**

### Proof-of-work

**Why Proof-of-Work?**

- It provided a simple and moderately effective consensus algorithm, allowing nodes in the network to collectively agree on a set of canonical updates to the state of the Bitcoin ledger.
- It provided a mechanism for allowing free entry into the consensus process, solving the political problem of deciding who gets to influence the consensus, while simultaneously preventing sybil attacks.

**How Proof-of-Works works?**

Substituting a formal barrier to participation such as a requirements, a particular list with economic barrier - the weight of a single node in the consensus voting process is directly proportional to the computing power that the nodes brings.

### State Transition System

![State Transition System](https://user-images.githubusercontent.com/19762585/205472774-2ea6353a-22c9-48df-a9cd-60359a2a353e.png)

The ledger of a cryptocurrency such as Bitcoin can be thought of as a state transition system, where there is a “state” consisting of the ownership status of all existing bitcoins and a “state transition function” that takes a state and transaction and outputs a new state which is the result. Can be formally define:

```bash
APPLY(S,TX) -> S' or ERROR
```

The “state” in Bitcoin is the collection of all coins (Technically, “unspent transaction outputs” or UTXO) that have been minted and not yet spent, with each UTXO having a denomination and an owner (defined by a 20-byte address which is essentially a cryptographic public key). A transaction contains one or more inputs, with each input containing a reference to an existing UTXO and a cryptographic signature produced by the private key associated with the owner’s address, and one or more outputs, with each output containing a new UTXO to be added to the state.

The state transition function APPLY(S,TX) → S’ can be defined roughly as follows:

1. For each input in TX:
    - If referenced UTXO not exist, return ERROR
    - If provided signature does not match with referenced UTXO, return ERROR
2. If the sum of the denominations of all input UTXO is less than the sum of the denominations of all output UTXO, return ERROR.
3. Return’s with all input UTXO removed and all output UTXO added.

### Mining

![Mining](https://user-images.githubusercontent.com/19762585/205472829-9a0e1c68-94b7-49fa-9564-66e28d57469f.png)


**Why Mining concept needed?**

If we are trying to build a decentralized system, we need to combine the state transaction system with a consensus system in order to ensure that everyone agrees on the order of transactions.

Bitcoin decentralized consensus process requires nodes in the network to continuously attempt to produce packages of transactions called “Blocks”. The network is intended to produce roughly one block every ten minutes, with each block containing a timestamp, a nonce, a reference to (ie. hash of) the previous block and a list of all of the transactions that have taken place since the previous block. Over time, this create a persistent, ever-growing, “blockchain” that constantly updates to represent the latest state of the Bitcoin ledger.

Algorithm for checking if a block is valid:

1. Check if the previous block referenced by the new block is valid and exists.
2. Check that the timestamp of the new block is greater than the previous block and less than 2 hours into the future.
3. Check Proof-of-Work on the block is valid.
4. Let S[0] be the state at the end of the previous block.
5. Suppose TX is the block’s transaction list with n transactions. For all i in 0…n-1, set S[i+1] = APPLY(S[i], TX[i]) If any application returns an error, exit and return false.
6. Return true, and register S[n] as the state at the end of this block.

The precise condition of “Proof-of-Work” is that the double-SHA256 hash of every block, treated as a 256-bit number, must be less than a dynamically adjusted target, which as of the time of this writing is approximately 2^187.  The purpose of this is to make block creation computationally "hard", thereby preventing sybil attackers from remaking the entire blockchain in their favor. Because SHA256 is designed to be a completely unpredictable pseudorandom function, the only way to create a valid block is simply trial and error, repeatedly incrementing the nonce and seeing if the new hash matches.

To compensate miners for this computational work, the miner of every block is entitled to include a transaction giving themselves 25 BTC out of nowhere.

### Merkle Trees

![Merkle Trees](https://user-images.githubusercontent.com/19762585/205472867-66cc684b-35e6-4762-938d-7b40ba628f0d.png)


An important scalability feature of Bitcoin is that the block is stored in a multi-level data structure. The "hash" of a block is actually only the hash of the block header, a roughly 200-byte piece of data that contains the timestamp, nonce, previous block hash and the root hash of a data structure called the Merkle tree storing all transactions in the block. A Merkle tree is a type of binary tree, composed of a set of nodes with a large number of leaf nodes at the bottom of the tree containing the underlying data, a set of intermediate nodes where each node is the hash of its two children, and finally a single root node, also formed from the hash of its two children, representing the "top" of the tree. The purpose of the Merkle tree is to allow the data in a block to be delivered piecemeal: a node can download only the header of a block from one source, the small part of the tree relevant to them from another source, and still be assured that all of the data is correct. The reason why this works is that hashes propagate upward: if a malicious user attempts to swap in a fake transaction into the bottom of a Merkle tree, this change will cause a change in the node above, and then a change in the node above that, finally changing the root of the tree and therefore the hash of the block, causing the protocol to register it as a completely different block (almost certainly with an invalid proof-of-work).

## Ethereum Architecture

### Ethereum Accounts

In Ethereum, the state is made up of objects called “accounts”, with each account having a 20-byte address and state transitions being direct transfers of value and information between accounts. An Ethereum account contains four fields:

- the **********nonce**********, a counter used to make sure each transaction can only be processed once
- the account’s current **************************ether balance**************************
- the account’s ******************************contract code,****************************** if present
- the account’s ****************storage**************** (empty by default)

In general, there are two types of accounts: ****************************************************externally owned accounts,**************************************************** controlled by private keys, and **********************************contract accounts**********************************, controlled by their contract code.

Note that “contracts” in Ethereum should not be seen as something that should be “fulfilled” or “compiled with”; rather they are more like “autonomous agents” that live inside of the Ethereum execution env, always executing a specific piece of code when “poked” by a message or transaction, and having direct control over their own ether balance and their own key/value store to keep track or persistent variables.

### Messages and Transactions

The term "transaction" is used in Ethereum to refer to the signed data package that stores a message to be sent from an externally owned account. Transactions contain:

- The recipient of the message
- A signature identifying the sender
- The amount of ether to transfer from the sender to the recipient
- An optional data field
- A ******************STARTGAS****************** value, representing the maximum number of computational steps the transaction execution is allowed to take
- A ****************GASPRICE**************** value, representing the fee the sender pays per computational step

Gas is an important concept in Ethereum to prevent the network from denial of service attack, since there is limit to computation they can perform and they have to pay for every on-chain computation and resources executed.

### Messages

Contracts have the ability to send "messages" to other contracts. Messages are virtual objects that are never serialized and exist only in the Ethereum execution environment. A message contains:

- The sender of the message (implicit)
- The recipient of the message
- The amount of ether to transfer alongside the message
- An optional data field
- A ************************STARTGAS************************ value

Basically, Messages are just like transactions but called by contract instead of external actor. A messages produced when a contract currently executing code executes the **********CALL********** opcode, which produces and executes a message. Like a transaction, message lead to the recipient account running its code.

**Note** : the gas allowance assigned by a transaction or contract applies to the total gas consumed by that transaction and all sub-executions.

### Ethereum State Transition Function

![Ethereum State Transition Function](https://user-images.githubusercontent.com/19762585/205472895-21460a32-098c-4289-993c-cf97e7e8e22c.png)


The Ethereum state transition function, ****************************************APPLY(S,TX) → S’**************************************** can be defined as follows:

1. Check if the transaction is well-formed (ie. has the right number of values), the signature is valid, and the nonce matches the nonce in the sender’s account. If not, return an error.
2. Calculate the transaction fee as **STARGAS * GASPRICE,** and determine the sending address from the signature. Subtract the fee from the sender’s account balance and increment the sender’s nonce. If there is not enough balance to spend, return an error.
3. Initialize **GAS = STARTGAS**, and take off a certain quantity of gas per byte to pay for the bytes in the transaction.
4. Transfer the transaction value from the sender’s  account to the receiving account. If the receiving account does not yet exist, create it. If the receiving account is a contract, run the contract’s code either to completion or until the execution runs out of gas.
5. If the value transfer failed because the sender did not have enough money, or the code execution ran out of gas, revert all state changes except the payment of the fees, and add the fees to the miners’ account.
6. Otherwise, refund the fees for all remaining gas to the sender, and send the fees paid for gas consumed to the miner.

### Code Execution

The code in Ethereum is written in a low-level, stack-based bytecode language, referred to as “Ethereum virtual machine code” or “EVM code”.

The operations have access to three types of space in which to store data:

- The **************stack,************** a last-in-first-out container to which values can be pushed and popped
- ****************Memory,**************** an infinitely expandable byte array
- The contract’s long-term ****************storage,**************** a key/value store. Unlike stack and memory, which reset after computation ends, storage persist for the long term.

The code can also access the value, sender and data of the incoming message, as well as block header data, and the code can also return a byte array of data as an output.

### Blockchain and Mining

!Blockchain and Mining](https://user-images.githubusercontent.com/19762585/205472915-54ece41e-4095-4462-b3c3-1a020f966d6c.png)


The main difference between Ethereum and Bitcoin with regard to the blockchain architecture is that, unlike Bitcoin, Ethereum blocks contain a copy of both the transaction list and the most recent state. The basic block validation algorithm in Ethereum is as follows:

1. Check if the previous block referenced exists and is valid.
2. Check that the timestamp of the block is greater than that of the referenced previous block and less than 15 minutes into the future.
3. Check that the block number, difficulty, transaction root, uncle root and gas limit (various low-level Ethereum-specific concepts) are valid.
4. Check that the proof-of-work on the block is valid.
5. Let S[0] be the state at the end of previous block.
6. Let TX be the block’s transaction list, with n transactions. For all i in 0…n-1, set S[i+1] = APPLY(S[i], TX[i}) if any applications return an error, or if the total gas consumed in the block up until this point exceeds the `GASLIMIT`, return an error.
7. Let `S_FINAL` be `S[n]`, but adding the block reward paid to the miner.
8. Check if the Merkle tree root of the state `S_FINAL` is equal to the final state root provided in the block header. If it is, the block is valid; otherwise, is is not valid.

between two adjacent blocks the vast majority of the tree should be the same, and therefore the data can be stored once and referenced twice using pointers (ie. hashes of subtrees). A special kind of tree known as a "Patricia tree" is used to accomplish this, including a modification to the Merkle tree concept that allows for nodes to be inserted and deleted, and not just changed, efficiently.

Where are the smart contract code execution happened? It is part of state transition function, which is part of the block validation algorithm, so if a transaction is added into the block B the code execution spawned by that transaction will be executed by all nodes, now and in the future, that download and validate block B.

## Applications

In general there are three types of applications on top of Ethereum :

- Financial (sub-currencies, financial derivatives, hedging contracts, saving wallets, wills etc.)
- Semi-financial applications (self-enforcing bounties for solutions to computational problems)
- Others (DAO, voting system, etc.)

### Token Systems

On-blockchain token systems have many applications ranging from sub-currencies representing assets such as USD or gold to company stocks, individual tokens representing smart property, secure unforgeable coupons, and even token system with no ties to conventional value at all, used as point systems for incentivization.

The key point to understand is that all a currency, or token system, fundamentally is, a database with one operation: 

***subtract X units from A and give X units to B, with the proviso that (i) A had at least X units before the transaction and (ii) the transaction is approved by A. All that it takes to implement a token system is to implement this logic into a contract***.

The basic code for Token System in Serpent as follows:

```bash
def send(to, value):
	if self.storage[msg.sender] >= value
		 self.storage[msg.sender] = self.storage[msg.sender] - value
		 self.storage[to] = self.storage[to] + value
```

### Financial derivatives and Stable-Value Currencies

Financial derivatives often require external price ticker, for example, a very desirable application is a smart contract that hedges against the volatility of ether (or another cryptocurrency) with respect to the US dollar, but doing this requires the contract to know value of ETH/USD.

Given that critical ingredient, the hedging contract would look as follows:

1. Wait for party A to input 1000 ether.
2. Wait for party B to input 1000 ether.
3. Record the USD value of 1000 ether, calculated by querying the data feed contract, in storage, say this is $x.
4. After 30 days, allow A or B to "reactivate" the contract in order to send $x worth of ether (calculated by querying the data feed contract again to get the new price) to A and the rest to B.

### Identity and Reputation Systems

One of the example is Namecoin, which servers pretty much like DNS, mapping domain “bitcoin.org” or “said.bit” to an IP address. Other use case include email authentication and potentially more advanced reputation system.Here is the basic contract to provide a Namecoin-like name registration system on Ethereum:

```bash
def register(name, value):
	if !self.storage[name]:
		  self.storage[name] = value
```

### Decentralized File Storage

The key underpinning piece of such a device would be what we have termed the "decentralized Dropbox contract". This contract works as follows. First, one splits the desired data up into blocks, encrypting each block for privacy, and builds a Merkle tree out of it. One then makes a contract with the rule that, every N blocks, the contract would pick a random index in the Merkle tree (using the previous block hash, accessible from contract code, as a source of randomness), and give X ether to the first entity to supply a transaction with a simplified payment verification-like proof of ownership of the block at that particular index in the tree. When a user wants to re-download their file, they can use a micropayment channel protocol (eg. pay 1 szabo per 32 kilobytes) to recover the file; the most fee-efficient approach is for the payer not to publish the transaction until the end, instead replacing the transaction with a slightly more lucrative one with the same nonce after every 32 kilobytes.

### Decentralized Autonomous Organizations

The general concept of a “DAO” is that of a virtual entity that has a certain set of members or shareholders which, perhaps with 67% majority, have the right to spend the entity’s funds and modify its code. The members would collectively decide on how the organization should allocate its funds.

there would be three transaction types, distinguished by the data provided in the transaction:

- `[0,i,K,V]` to register a proposal with index `i` to change the address at storage index `K` to value `V`
- `[1,i]` to register a vote in favor of proposal `i`
- `[2,i]` to finalize proposal `i` if enough votes have been made

## Miscellanea and Concerns

### Modified GHOST Implementation

The “Greedy Heaviest Observed Subtree” GHOST protocol is an innovation first introduced by Yonatan Sompolinsky and Aviv Zohar. The motivation behind GHOST is that blockchains with fast confirmation times currently suffer from reduced security due to a high stale rate - because blocks take a certain time to propagate through the network, if miner A mines a block and then miner B happens to mine another block before miner A’s block proagates to B, miner B’s block will end up wasted and will not contribute to network security. Furthermore, there is centralization issue: if miner A is a mining pool with 30% hashpower and B has 10% hashpower, A will have a risk of producing a stale block 70% of the time (since the other 30% of the time A produced the last block and so will get mining data immediately) whereas B will have a risk of producing a stale block 90% of the time. Thus, if the block interval is short enough for the stale rate to be high, A will be substantially more efficient simply by virtue of its size.

Ethereum implements a **simplified version of GHOST** which only goes down seven levels. Specifically, it is defined as follows:

1. A block must specify a parent, and it must specify 0 or more uncles
2. An uncle included in block B must have the following properties:
    - It must be a direct child of the kth generation ancestor of B where 2 ≤ k ≤ 7.
    - It cannot be an ancestor of B.
    - An uncle must be a valid block header, but does not need to be a previously verified or even valid block
    - An uncle must be different from all uncles included in previous blocks and all other uncles included in the same block (non-double-inclusion)
    - For every uncle U in block B, the miner of B gets an additional 3.125% added to its coinbase reward and the miner of U gets 93.75% of standard coinbase reward.

### Fees

market-based mechanism, when given a particular inaccurate simplifying assumption, magically cancels itself out. The argument is as follows. Suppose that:

1. A transaction leads to `k` operations, offering the reward `kR` to any miner that includes it where `R` is set by the sender and `k` and `R` are (roughly) visible to the miner beforehand.
2. An operation has a processing cost of `C` to any node (ie. all nodes have equal efficiency)
3. There are `N` mining nodes, each with exactly equal processing power (ie. `1/N` of total)
4. No non-mining full nodes exist.

A miner would be willing to process a transaction if the expected reward is greater than the cost. Thus, the expected reward is `kR/N` since the miner has a `1/N` chance of processing the next block, and the processing cost for the miner is simply `kC`. Hence, miners will include transactions where `kR/N > kC`, or `R > NC`. Note that `R` is the per-operation fee provided by the sender, and is thus a lower bound on the benefit that the sender derives from the transaction, and `NC` is the cost to the entire network together of processing an operation. Hence, miners have the incentive to include only those transactions for which the total utilitarian benefit exceeds the cost.

However, there are several important deviations from those assumptions in reality:

1. The miner does pay a higher cost to process the transaction than the other verifying nodes, since the extra verification time delays block propagation and thus increases the chance the block will become a stale.
2. There do exist nonmining full nodes.
3. The mining power distribution may end up radically inegalitarian in practice.
4. Speculators, political enemies and crazies whose utility function includes causing harm to the network do exist, and they can cleverly set up contracts where their cost is much lower than the cost paid by other verifying nodes.

(1) provides a tendency for the miner to include fewer transactions, and (2) increases `NC`; hence, these two effects at least partially cancel each other out.[How?](https://github.com/ethereum/wiki/issues/447#issuecomment-316972260) (3) and (4) are the major issue; to solve them we simply institute a floating cap: no block can have more operations than `BLK_LIMIT_FACTOR` times the long-term exponential moving average. Specifically:

```
blk.oplimit = floor((blk.parent.oplimit \* (EMAFACTOR - 1) +
floor(parent.opcount \* BLK\_LIMIT\_FACTOR)) / EMA\_FACTOR)
```

### Computation And Turing-Completeness

The alternative to Turing-completeness is Turing-incompleteness, where `JUMP` and `JUMPI` do not exist and only one copy of each contract is allowed to exist in the call stack at any given time. With this system, the fee system described and the uncertainties around the effectiveness of our solution might not be necessary, as the cost of executing a contract would be bounded above by its size. Additionally, Turing-incompleteness is not even that big a limitation; out of all the contract examples we have conceived internally, so far only one required a loop, and even that loop could be removed by making 26 repetitions of a one-line piece of code. Given the serious implications of Turing-completeness, and the limited benefit, why not simply have a Turing-incomplete language? In reality, however, Turing-incompleteness is far from a neat solution to the problem. To see why, consider the following contracts:

```
C0: call(C1); call(C1);
C1: call(C2); call(C2);
C2: call(C3); call(C3);
...
C49: call(C50); call(C50);
C50: (run one step of a program and record the change in storage)

```

Now, send a transaction to A. Thus, in 51 transactions, we have a contract that takes up 2^50 computational steps. Miners could try to detect such logic bombs ahead of time by maintaining a value alongside each contract specifying the maximum number of computational steps that it can take, and calculating this for contracts calling other contracts recursively, but that would require miners to forbid contracts that create other contracts (since the creation and execution of all 26 contracts above could easily be rolled into a single contract). Another problematic point is that the address field of a message is a variable, so in general it may not even be possible to tell which other contracts a given contract will call ahead of time. Hence, all in all, we have a surprising conclusion: Turing-completeness is surprisingly easy to manage, and the lack of Turing-completeness is equally surprisingly difficult to manage unless the exact same controls are in place - but in that case why not just let the protocol be Turing-complete?

### Currency and Issuance

The Ethereum network includes its own built-in currency, ether, which serves the dual purpose of providing a primary liquidity layer to allow for efficient exchange between various types of digital assets and, more importantly, of providing a mechanism for paying transaction fees. For convenience and to avoid future argument (see the current mBTC/uBTC/satoshi debate in Bitcoin), the denominations will be pre-labelled:

- 1: wei
- 10^12: szabo
- 10^15: finney
- 10^18: ether

The issuance model will be as follows:

- Ether will be released in a currency sale at the price of 1000-2000 ether per BTC, a mechanism intended to fund the Ethereum organization and pay for development that has been used with success by other platforms such as Mastercoin and NXT. Earlier buyers will benefit from larger discounts. The BTC received from the sale will be used entirely to pay salaries and bounties to developers and invested into various for-profit and non-profit projects in the Ethereum and cryptocurrency ecosystem.
- 0.099x the total amount sold (60102216 ETH) will be allocated to the organization to compensate early contributors and pay ETH-denominated expenses before the genesis block.
- 0.099x the total amount sold will be maintained as a long-term reserve.
- 0.26x the total amount sold will be allocated to miners per year forever after that point.

![Issuance](https://user-images.githubusercontent.com/19762585/205473026-3910e54b-2624-467b-8932-ee64805594f7.png)


### Long-Term Supply Growth Rate (percent)

![Long-Term Supply Growth Rate](https://user-images.githubusercontent.com/19762585/205473094-aa667fa5-af98-40b0-bb3c-1a674fbdcdda.png)


### Mining Centralization

The current intent at Ethereum is to use a mining algorithm where miners are required to fetch random data from the state, compute some randomly selected transactions from the last N blocks in the blockchain, and return the hash of the result. This has two important benefits. First, Ethereum contracts can include any kind of computation, so an Ethereum ASIC would essentially be an ASIC for general computation - ie. a better CPU. Second, mining requires access to the entire blockchain, forcing miners to store the entire blockchain and at least be capable of verifying every transaction. This removes the need for centralized mining pools; although mining pools can still serve the legitimate role of evening out the randomness of reward distribution, this function can be served equally well by peer-to-peer pools with no central control.

### Scalability

In the near term, Ethereum will use two additional strategies to cope with this problem. First, because of the blockchain-based mining algorithms, at least every miner will be forced to be a full node, creating a lower bound on the number of full nodes. Second and more importantly, however, we will include an intermediate state tree root in the blockchain after processing each transaction. Even if block validation is centralized, as long as one honest verifying node exists, the centralization problem can be circumvented via a verification protocol. If a miner publishes an invalid block, that block must either be badly formatted, or the state `S[n]`
 is incorrect. Since `S[0]`
 is known to be correct, there must be some first state `S[i]`
 that is incorrect where `S[i-1]`
 is correct. The verifying node would provide the index `i`
, along with a "proof of invalidity" consisting of the subset of Patricia tree nodes needing to process `APPLY(S[i-1],TX[i]) -> S[i]`
. Nodes would be able to use those nodes to run that part of the computation, and see that the `S[i]`
 generated does not match the `S[i]`
 provided.

### Notes that need to review more often

About Long-Term Supply Growth Rate
