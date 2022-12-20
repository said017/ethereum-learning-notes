# 18-MagicNum

1. To solve this problem, we have to understand basics opcode in EVM : https://ethereum.org/en/developers/docs/evm/opcodes/

2. There is size restriction of 10 opcodes, to solve this we have two create two sets bytecode:

   - Initialization bytecode: It is responsible for preparing the contract and returning the runtime bytecode.
   - Runtime bytecode: This is the actual code run after the contract creation. In other words, this contains the logic of the contract.

3. Runtime bytecode, created from opcode available at `runtime.txt` :

```shell
PUSH 0x2A  // push the requested value 42
PUSH 0x80  // location of storage, could be any
MSTORE     // store to memory

PUSH 32   // length of offset
PUSH 0x80   // value stored at slot 0x80 from code above
RETURN
```

then compile it using `evm compile runtime.txt`

4. Init bycode, created from opcode available at `init.txt`. These will be responsible for loading our runtime opcodes in memory and returning it to the EVM.

To copy code, we need to use the CODECOPY(t, f, s) opcode which takes 3 arguments.

t: The destination offset where the code will be in memory. Let's save this to 0x00 offset.
f: This is the current position of the runtime opcode which is not known as of now.
s: This is the size of the runtime code in bytes, i.e., 602a60805260206080f3 - 10 bytes long. :

```shell
PUSH 0x0A // the 10 bytes long
PUSH 0x0c // the current position of runtime opcode
PUSH 0x00 // start
CODECOPY

PUSH 0x0A // the 10 bytes length
PUSH 0x00 // value stored start at slot 0
RETURN
```

then compile it using `evm compile init.txt`

5. combine the bytecodes `<initcode>+<runtimecode>` for example `600a600c600039600a6000f3 + 602a60505260206050f3` to `600a600c600039600a6000f3602a60505260206050f3`

6. Create contract using `create` command, the script available at `MagicNumSend.sol`.

reference :

- https://blog.dixitaditya.com/ethernaut-level-18-magicnumber
- https://hackmd.io/@cupidhack/Hk6SKZGCu
- https://ethereum.org/en/developers/docs/evm/opcodes/
- https://ardislu.dev/raw-bytecode-evm
- https://jeancvllr.medium.com/solidity-tutorial-all-about-assembly-5acdfefde05c
