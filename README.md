# My Ethereum Learning Notes

_This repo are meant to be Proof of my knowledge about Ethereum network, Solidity, the development tools and the ecosystem, also as notes and pointer to other resources if needed, structured in a way i think most people and employer think the best way to learn about Ethereum_

- [Ethereum Whitepaper Notes](https://github.com/said017/ethereum-learning-notes/blob/main/01-ethereum-whitepaper-notes.md)
  - Learn about the history of blockchain, the background behind Ethereum, main objective of Ethereum, Blockchain general key concepts (Proof-of-Work, State Transition System, Mining, Merkle Trees). Then go to Ethereum Architecture (Ethereum accounts, messages and transactions for EOA and contract, Ethereum State Transition System, Code execution, Ethereum mining), Appilication that can run on Ethereum. Modified GHOST implementation, the fees design, currency and issuance and scalability problem.
- [Ethereum Yellowpaper Notes](https://github.com/said017/ethereum-learning-notes/blob/main/02-ethereum-yellowpaper-notes.md)

  - Learn about blockchain paradigm (mining, protocols etc.), Blocks, State and Transactions, Transaction Execution, Contract Creation, Message Call, Execution Model, Fee Schedule, Virtual Machine Specification.

- [Mastering Ethereum Book](https://github.com/ethereumbook/ethereumbook)

  - If you already read whitepaper and yellowpaper, the first three chapter only reviewing knowledge you already have,
  - chapter 4 and 5 teach about cryptography tools used in ethereum, how to derive private & public key, and learn about wallets technology (nondeterministic, deterministic, best practices - Mnemonic code words, based on BIP-39, HD wallets based on BIP-32, Multipurpose HD wallet structure based on BIP-43, Multicurrency and multiaccount wallets based on BIP-44).
  - Chapter 6 explain about Transaction, the structure of it (nonce, gas, gasLimit, gasPrice, from, to , data, value), special creation transaction, how to sign a transaction and verify it, check `03-mastering-ethereum-book/signing-tx.js` to see the code implementation, transaction propagation and recording it on blockchain.
  - Chapter 7 explain about Solidity language, although a little bit old, should give the basics and history about Solidity, the most important part is when explaining about `call` and `delegatecall` as in `03-mastering-ethereum-book/CallExample.sol` code, Also i previously noted Solidity basics on `03-mastering-ethereum-book/solidity-basics.md`.
  - Chapter 9 explain about Solidity Smart Contract Security, best practices, risk and anti patterns, and some old but insightful vulnerabilities. I learn to solved some of this problems in [this local ethernauts](https://github.com/said017/local-ethernauts).
  - Chapter 10 explain about Tokens, How they are used, token standards such as ERC20, ERC223, ERC777, ERC721, to learn the update standards, better check [here](https://ethereum.org/en/developers/docs/standards/tokens/#:~:text=Here%20are%20some%20of%20the,for%20artwork%20or%20a%20song).
  - Chapter 11 explain about Oracle, why we need it, use cases and example, design pattern (request–response, publish-subscribe, and immediate-read), computations and decentralized oracles.
  - Chapter 12 explain about DApps, basics example, and explanation about how ENS (Ethereum Name Service) works.
  - Chapter 13 explain about EVM, while upto date information can be found in whitepaper/yellowpaper, the explanation about bytecode compiler, deployment bytcode and runtime bytecode dissambling bytecode using [Ethersplay](https://github.com/crytic/ethersplay) and how transaction processed in bytecode.
  - Chapter 14 explain the broad concept of Consensus, PoW, PoS, read other resource for more upto date information.

- [Secureum Mindmap](https://github.com/x676f64/secureum-mind_map) \
  Since my main goal to learn is to become Solidity Smart Contract Auditor, i follow the guideline in secureum mindmap
  - Slot 1 is learning the concept of EVM
  - Slot 2 learn about basics Solidity
  - Slot 3 learn advance Solidity concepts, common libraries, best practices and DeFi contracts.
  - Slot 4 Pitfalls and Best Practices 101, common issues that happened but most of them already fixed and not found on recent smart contracts.
    - Did [Ethernaut](https://ethernaut.openzeppelin.com/) and write down solutions on `ethernauts-solutions`
    - Learn about [Slither](https://github.com/crytic/slither), smart contract static analysis framework, great tools to run pre-defined vulnerabilities, easy to use.
    - Did [DamnVulnerableDeFi](https://github.com/tinchoabbate/damn-vulnerable-defi) and write solutions.
