const bip39 = require("bip39");

// defaults to BIP39 English word list
// uses HEX strings for entropy
// mnemonic
const mnemonic = bip39.entropyToMnemonic("0c1e24e5917779d297e14d45f14e1a1a");

console.log("Mnemonic from Entropy :", mnemonic);

// generate 512 bits seed (no passphrase)
const seed = bip39.mnemonicToSeedSync(mnemonic).toString("hex");

// generate 512 bits seed (with passprase)
const seedWithPassphrase = bip39
  .mnemonicToSeedSync(mnemonic, "SuperDuperSecret")
  .toString("hex");
console.log("Seed from mnemonic :", seed);
console.log("Seed from mnemonic (with passpharese) :", seedWithPassphrase);
