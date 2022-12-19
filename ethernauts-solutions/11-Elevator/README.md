# 11-Elevator

1. in `Elevator.sol` defined `Building` interface and use external implementation of that interface to do checking before execute some logic. This leave `Elevator.sol` vulnerable since anyone can provide `Building` implementation with malicious logic.

2. `Building.sol` implement malicious checking to bypass the first check and change the value at second check.
