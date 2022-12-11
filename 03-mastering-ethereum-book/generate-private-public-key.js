let elliptic = require("elliptic");
let ec = new elliptic.ec("secp256k1");
let sha3 = require("js-sha3");

// let keyPair = ec.genKeyPair();
let keyPair = ec.keyFromPrivate(
  "f8f8a2f43c8376ccb0871305060d7b27b0554d2cc72bccf41b2705608452f315"
);
let privKey = keyPair.getPrivate("hex");
let pubKey = keyPair.getPublic();
console.log(`Private key: ${privKey}`);
let pubKeyTo = pubKey.encode();
pubKeyTo.shift();
console.log("Public key :", pubKey.encode("hex").substr(2));
console.log("Public key (compressed):", pubKey.encodeCompressed("hex"));

// // keccak hash of public key
let hash = sha3.keccak256(pubKeyTo);
console.log("Keccak hash of pubKey :", hash);

let ethereumAddress = hash.substr(-40);
console.log("Ethereum Address :", ethereumAddress);

function toChecksumAddress(address) {
  address = address.toLowerCase().replace("0x", "");
  var hash = sha3.keccak256(address);
  var ret = "0x";

  for (var i = 0; i < address.length; i++) {
    if (parseInt(hash[i], 16) >= 8) {
      ret += address[i].toUpperCase();
    } else {
      ret += address[i];
    }
  }

  return ret;
}

console.log("checkSum result (EIP-55) :", toChecksumAddress(ethereumAddress));
