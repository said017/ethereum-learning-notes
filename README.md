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
  - Slot 5 Pitfalls and Best Practices 201, learn about 10 secure design principles and more pitfalls and ERC standards.
  - Did [DamnVulnerableDeFi](https://github.com/said017/ethereum-learning-notes/tree/main/damn-vunerable-defi-solutions) and write solutions.
  - Slot 6 Audit Techniques & Tools 101, learn about the goal, the non-goal of audit, targets, needs, types, timeline, effort, pre-reqs, limitations, reports, classification, OWASP difficulty and impact, checklist, analysis techniques, specification, documentation, testing, formal verification, manual analysis. The detailed list available on `slot-6-audit-techniques-notes.md`.
  - Slot 6 also mention about manual review approach, detail on `slot-6-manual-review-approach.md`, and the typical audit process on `slot-6-audit-process.md`.

- EVM Knowledge
  deep dive into EVM knowledge, trough these [resources](https://noxx3xxon.notion.site/noxx3xxon/The-EVM-Handbook-bb38e175cc404111a391907c4975426d)

  - Learn how EVM bytecode running under the hood (Runtime vs Bytecode), function selector, function wrapper, function bodies, metadata hash. (From Openzepplin - Deconstructing a Solidity Contract)
  - Learn how EVM storage and memory works. (From Noxx - EVM Deep Dives)
  - Solve [Fvictorio - EVM Puzzles](https://github.com/fvictorio/evm-puzzles), my solution availables in [here](https://github.com/said017/ethereum-learning-notes/tree/main/evm-puzzles-solutions)

- DeFi Knowledge
  learn and take notes from "How To DeFi : Beginner" book by CoinGecko, also deep dive from other resources.
  - Compound protocol, an Ethereum-based, open-source money market protocol where anyone can lend or borrow cryptocurrencies frictionlessly. Notes available [here](https://github.com/said017/ethereum-learning-notes/tree/main/defi-projects-deep-dive).
  - create Compound protocol supplying and redeem example using foundry [here](https://github.com/said017/defi-examples/blob/main/test/CompoundErc20.t.sol).
  - create Compound protocol borrow and repay example using foundry [here](https://github.com/said017/defi-examples/blob/main/test/CompoundErc20Borrow.t.sol).
  - Learn about Uniswap V1,V2 from [here](https://uniswapv3book.com/). V1 is decentralized DEX using AMM and pool providing exchange from ETH to Token, V2 improve a lot of aspect of V1, but the main thing is efficient exchange for Token to Token.
  - Learn about Uniswap V3 from [here](https://uniswapv3book.com/). V3 improves capital efficiency by allowing to put more liquidity into a narrow price range, which makes Uniswap more diverse: it can now have pools configured for pairs with different volatility. This is how V3 improves V2. Also create the clone of the code provided in the uniswapv3book tutorial
- Start to Learn from [DeFiHackLabs](https://github.com/SunWeb3Sec/DeFiHackLabs) and [DeFiVulnLabs](https://github.com/SunWeb3Sec/DeFiVulnLabs)

  - learn all DeFiVulnLabs, run the PoC, and take notes (`defi-vuln-labs-notes.md`).
  - start to deep dive into 101 root cause analysis of past DeFi hacks notion page.

- Start Practice Audit from Solidity Lab

  - Auditing contract based on [ERC1726](https://github.com/Roger-Wu/erc1726-dividend-paying-token).
  - Start practice audit - Diva Protocol.

- Reading trough [solcurity](https://github.com/transmissions11/solcurity).
- Start participating in Sherlock contest :
  - submit high and medium issues - Derby Protocol contest.
  - ongoing audit Kairos Protocol contest (1 High, 4 medium).
- Check resources from [Web3DAO](https://www.web3securitydao.xyz/collaborating/resources).
- Read Smart Contract Security Verification Standard [here](https://github.com/ComposableSecurity/SCSVS).
- Read trough QuillAudit [Roadmap](https://github.com/Quillhash/QuillAudit_Auditor_Roadmap).
- Learn invariant testing using Foundry from [this article](https://mirror.xyz/horsefacts.eth/Jex2YVaO65dda6zEyfM_-DXlXhOWCAoSpOx5PLocYgw).
- Reading C4 and Sherlock audit report.
  - 2022-04-backd
  - 2022-08-olympus
  - 2022-09-party-dao
  - 2022-09-y2k-finance
  - 2022-12-notional
  - 2022-09-notional
- Looking through Immunefi projects.
