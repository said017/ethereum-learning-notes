// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import "forge-std/Test.sol";
import "../src/Gate.sol";

contract GateTest is Test {
    address owner = vm.addr(1);
    address guardian;
    Gate gate;

    function setUp() external {
        vm.prank(owner);
        /*
            ORIGIN
            CALLER
            RETURNDATASIZE
            CALLDATALOAD
            PUSH1 0xe0
            SHR
            RETURNDATASIZE // this is for 0x0 - f00000000_bvvvdlt() selector (change this to returndatasize since it value is 0) 
            DUP2
            EQ
            PUSH1 23 
            JUMPI
            PUSH1 0x01 // this is for 0x1 - f00000001_grffjzz() selector  
            EQ
            PUSH1 23 
            JUMPI
            PUSH1 0x00
            DUP1
            REVERT
            JUMPDEST 
            POP // if it from 0x0, it will pop 0 in stack, if it from 0x1 selector, it will pop caller and will return origin
            PUSH1 32
            MSTORE 
            PUSH1 32
            DUP1
            RETURN 
        <RUNTIME CODE SIZE IS 32>
        */
        guardian = deployBytecode(
            "\x32\x33\x3d\x35\x60\xe0\x1c\x3d\x81\x14\x60\x17\x57\x60\x01\x14\x60\x17\x57\x60\x00\x80\xfd\x5b\x50\x60\x20\x52\x60\x20\x80\xf3"
        );
        gate = new Gate();
    }

    // Create contract from bytecode
    function deployBytecode(bytes memory bytecode) public returns (address) {
        address retval;
        bytes memory code = abi.encodePacked(
            hex"60_20_60_0c_60_00_39_60_20_60_00_f3",
            bytecode
        );

        /*
        0x00    0x60         0x6020      PUSH1 0x20          // push size of the code (32 bytes)
        0x01    0x60         0x600c      PUSH1 0x0c          // push the start of the code or length of init bytecode (10 bytes)
        0x02    0x60         0x6000      PUSH1 0x00          // start 
        0x03    0x39         0x39        CODECOPY            // copy the runtime code
        0x04    0x60         0x6020      PUSH1 0x20          // push length runtime code size
        0x05    0x60         0x6000      PUSH1 0x00          // value stored at slot 0       
        0x06    0xf3         0xf3        RETURN              // return 
        <CODE>
        */

        assembly {
            retval := create(0, add(code, 32), mload(code))
        }

        return retval;
    }

    function test() public {
        console.log(guardian);
        console.log(address(gate)); // to check the address gate
        console.log(tx.origin); // to check the tx.origin
        gate.open(guardian);
        assertEq(gate.opened(), true);
    }
}
