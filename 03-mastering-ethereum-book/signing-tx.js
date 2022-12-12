// Load requirements first:
//
// npm init
// npm install ethereumjs-tx
//
// Run with: $ node raw_tx_demo.js
var { Chain, Common, Hardfork } = require("@ethereumjs/common");
var { Transaction, FeeMarketEIP1559Transaction } = require("@ethereumjs/tx");

const txData = {
  nonce: "0x0",
  gasPrice: "0x09184e72a000",
  gasLimit: "0x30000",
  to: "0xb0920c523d582040f2bcb1bd7fb1c7c1ecebdb34",
  value: "0x00",
  data: "",
  v: "0x1c", // Ethereum mainnet chainID
  r: 0,
  s: 0,
};

// this is legacy implementation
const common = new Common({
  chain: Chain.Mainnet,
  hardfork: Hardfork.Istanbul,
});
const tx = Transaction.fromTxData(txData, { common });
console.log("RLP-Encoded Tx: 0x" + tx.serialize().toString("hex"));

txHash = tx.hash(); // This step encodes into RLP and calculates the hash
console.log("Tx Hash: 0x" + txHash.toString("hex"));

// Sign transaction
const privKey = Buffer.from(
  "91c8360c4cb4b5fac45513a7213f31d4e4a7bfcb4630e9fbf074f42a203ac0b9",
  "hex"
);
tx.sign(privKey);

serializedTx = tx.serialize();
rawTx = "Signed Raw Transaction: 0x" + serializedTx.toString("hex");
console.log(rawTx);

// this is the EIP1559 London implementation
const common1559 = new Common({
  chain: Chain.Mainnet,
  hardfork: Hardfork.London,
});

const txData1559 = {
  data: "0x1a8451e600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
  gasLimit: "0x02625a00",
  maxPriorityFeePerGas: "0x01",
  maxFeePerGas: "0xff",
  nonce: "0x00",
  to: "0xcccccccccccccccccccccccccccccccccccccccc",
  value: "0x0186a0",
  v: "0x01",
  r: "0xafb6e247b1c490e284053c87ab5f6b59e219d51f743f7a4d83e400782bc7e4b9",
  s: "0x479a268e0e0acd4de3f1e28e4fac2a6b32a4195e8dfa9d19147abe8807aa6f64",
  chainId: "0x01",
  accessList: [],
  type: "0x02",
};

const tx1559 = FeeMarketEIP1559Transaction.fromTxData(txData1559, {
  common1559,
});
