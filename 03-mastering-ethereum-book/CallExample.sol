pragma solidity ^0.4.22;

contract calledContract {
    event callEvent(address sender, address origin, address from);

    function calledFunction() public {
        emit callEvent(msg.sender, tx.origin, this);
    }
}

library calledLibrary {
    event callEvent(address sender, address origin, address from);

    function calledFunction() public {
        emit callEvent(msg.sender, tx.origin, this);
    }
}

contract caller {
    function make_calls(calledContract _calledContract) public {
        // Calling calledContract and calledLibrary directly

        // this will call _calledContract using caller contract context
        _calledContract.calledFunction();

        // this will call calledLibrary using original calling context
        calledLibrary.calledFunction();

        // Low-level calls using the address object for calledContract
        require(
            // behave like the first call (_calledContract.calledFunction())
            address(_calledContract).call(bytes4(keccak256("calledFunction()")))
        );
        require(
            // behave like second call (calledLibrary.calledFunction())
            address(_calledContract).delegatecall(
                bytes4(keccak256("calledFunction()"))
            )
        );
    }
}
