## Solidity Concepts

### Solidity layout

**solidity** is the most used smart contract language with extension `**.sol**`

at the top of the code, always state **solidity** version to use `pragma solidity 0.x.x`

commenting code using double `//`

(optional) use `SPDX-License-Identifier` at the top of the code, to determine license for the code

`contract` is keyword to define the object after that is the smart contract, much like class concept in OOP.

```solidity
// SPDX-License-Identifier : MIT
pragma solidity ^0.8.8;

// this is at the simplest form, how you define a contract
contract SimpleStorage {

}
```

every contract creation in the network, considered as a transaction (modifying blockchain), that’s why you get gas transaction, value, transaction hash etc.

### Importing other Source Files

at a global level, you can use import statements of the following form:

```solidity
import "filename";
```

the `filename` part is called an import path, this form is not recommended for use, because it unpredictably pollutes the namespace because this statement imports all global symbols from “filename”.

the following example creates a new global symbol `symbolName` whose members are all the global symbols from `"filename"` :

```solidity
import * as symbolName from "filename";
// or use this format
import "filename" as symbolName;
// or like this, to rename while importing
import {symbol1 as alias, symbol2} from "filename";
```

### State Variables

state variables are variables whose values are permanently stored in contract storage.

```solidity
// SPDX-License-Identifier: MIT
pragma solidity >=0.4.0 <0.9.0;

contract SimpleStorage {
		uint storedData; // this is State variable
		// ...*
}
```

### Functions

functions are the executable units of code. Functions are usually defined inside a contract, but they can also be defined outside of contracts

```solidity
// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.1 <0.9.0;

contract SimpleAuction {
    function bid() public payable { // Function
        // ...
    }
}

// Helper function defined outside of a contract
function helper(uint x) pure returns (uint) {
    return x * 2;
}
```

### Function Modifiers

can be used to amend the semantics of functions in a declarative way.

```solidity
// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.4.22 <0.9.0;

contract Purchase {
		address public seller;

		modifier onlySeller() { // Modifier
				require(
						msg.sender == seller,
						"Only seller can call this."
				);
				_;
		}

		function abort() public view onlySeller { // Modifier usage
				// ...
		}
}
```

### Events

**events** are way to communicate with dapp front end / client application that something has happened on the blockchain, example :

to declare a new event:

```solidity
event Deposit(
	address indexed user,
  uint256 etherAmount,
	uint256 time
);
```

and then to emit the event:

```solidity
function deposit() public payable {
	/*
		some other code...
	*/

	emit Deposit(msg.sender, msg.value, block.timestamp);
}
```

### Errors

Errors allow you to define descriptive names and data for failure situations.

```solidity
// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.4;

/// Not enough funds for transfer. Requested `requested`,
/// but only `available` available.
error NotEnoughFunds(uint requested, uint available);

contract Token {
    mapping(address => uint) balances;
    function transfer(address to, uint amount) public {
        uint balance = balances[msg.sender];
        if (balance < amount)
            revert NotEnoughFunds(amount, balance);
        balances[msg.sender] -= amount;
        balances[to] += amount;
        // ...
    }
}
```

### Struct Types

structs are custom defined types that can group several variables, much like object in Javascript.

```solidity
// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.4.0 <0.9.0;

contract Ballot {
    struct Voter { // Struct
        uint weight;
        bool voted;
        address delegate;
        uint vote;
    }
}
```

### Enum Types

Enums can be used to create custom types with a finite set of ‘constant values’

```solidity
// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.4.0 <0.9.0;

contract Purchase {
    enum State { Created, Locked, Inactive } // Enum
}
```

## Value Types

the following types are also called value types because variables of these types will always be passed by value.

### Booleans

`bool` : The possible values are constants `true` and `false` .

Operators:

- `!` (logical negation)
- `&&` (logical conjuntion, “and”)
- `||` (logical disjuntion, “or”)
- `==` (equlity)
- `!=` (inequality)

### Integers

`int` / `uint` : Signed and unsigned integers of various sizes. Keywords `uint8` to `uint256` in steps of `8` (unsigned of 8 up to 256 bits) and `int8` to `int256` .

`uint` and `int` are aliases for `uint256` and `int256`, respectively.

Operators:

- Comparisons: `<=`, `<`, `==`, `!=`, `>=`, `>` (evaluate to `bool`)
- Bit operators: `&`, `|`, `^` (bitwise exclusive or), `~` (bitwise negation)
- Shift operators: `<<` (left shift), `>>` (right shift)
- Arithmetic operators: `+`, `-`, unary `-` (only for signed integers), `*`, `/`, `%` (modulo), `**` (exponentiation)

### Fixed Point Numbers

`fixed`/`ufixed`: Signed and unsigned fixed point number of various sizes. keyword `ufixedMxN` and `fixedMxN`, where `M` represents the number of bits taken by the type and `N` represents how many decimal points are available. `M` must be divisible by 8 and goes from 8 to 256 bits. `N` must be between 0 and 80, inclusive. `ufixed` and `fixed` are aliases for `ufixed128x18` and `fixed128x18`, respectively.

Operators:

- Comparisons: `<=`, `<`, `==`, `!=`, `>=`, `>` (evaluate to `bool`)
- Arithmetic operators: `+`, `-`, unary `-`, `*`, `/`, `%` (modulo)

### Address

The address type comes in two flavours, which are largely identical:

- `address`: Holds a 20 byte value (size of an Ethereum address).
- `address payable`: Same as `address`, but with the additional members `transfer` and `send`

Operators:

- `<=`, `<`, `==`, `!=`, `>=` and `>`

### Fixed-size byte arrays

The value types `bytes1`, `bytes2`, `bytes3`,…,`bytes32` hold a sequence of bytes from one to up to 32.

Operators:

- Comparisons: `<=`, `<`, `==`, `!=`, `>=`, `>` (evaluate to `bool`)
- Bit operators: `&`, `|`, `^` (bitwise exclusive or), `~` (bitwise negation)
- Shift operators: `<<` (left shift), `>>` (right shift)
- Index access: If `x` is of type `bytesI`, then `x[k]` for `0 <= k < I` returns the `k` th byte (read-only).

### Dynamically-sized byte array

`bytes`:

Dynamically-sized byte array. Not a value-type!

`string`:

Dynamically-sized UTF-8-encoded string. Not a value-type!

### Function Types

function types are the types of functions. Variables of function type can be assigned from functions and function parameters of function type can be used to pass functions to and return functions from function calls.

Internal functions can only be called inside the current contract (more specifically, inside the current code unit, which also includes internal library functions and inherited functions) because they cannot be executed outside of the context of the current contract. Calling an internal function is realized by jumping to its entry label, just like when calling a function of the current contract internally.

External functions consist of an address and a function signature and they can be passed via and returned from external function calls.

```solidity
function (<parameter types>) {internal|external} [pure|view|payable] [returns (<return types>)]
```

## Reference Types

value of reference type can be modified through multiple different names. Contrast this with value types where you get an independent copy whenever a variable of value type is used. Because of that, reference types have to be handled more carefully than value types. Currently, reference types comprise **structs, arrays** and **mappings**. if you use a reference type, you always have to explicitly proide the data area where he type is stored: `memory` (whose lifetime is limited to an external function call), `storage` (the location where the state variables are stored, where the lifetime is limited to the lifetime of a contract) or `calldata` (special data location that contains the function arguments).

### Arrays

Arrays can have a compile-time fixed size, or they have a dynamic size.

The type of an array of fixed size `k` and element type `T` is written as `T[k]`, and an array of dynamic size as `T[]`
.

### Structs

Solidity provides a way to define new types in the form of structs which is shown in the following example:

```solidity
// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0 <0.9.0;

//Defines a new type with two fields.
// Declaring a struct outside of a contract allows
// it to be shared by multiple contracts.
// Here, this is not really needed.
struct Funder {
		address addr;
		uint amount;
}

contract CrowdFunding {
		// Structs can also be defined inside contracts, which makes them
		// visible only there and in derived contracts.
		struct Campaign {
				address payable beneficiary;
				uint fundingGoal;
				uint numFunders;
				uint amount;
				mapping (uint => Funder) funders;
		}

		uint numCampaigns;
		mapping (uint => Campaign) campaigns;

		function newCampaign(address payable beneficiary, uint goal) public returns (uint campaignID) {
				campaignID = numCampaigns++; // campaignID is return variable
				// We cannot use "campaigns[campaignID] = Campaign(beneficiary, goal, 0, 0)"
        // because the right hand side creates a memory-struct "Campaign" that contains a mapping.
        Campaign storage c = campaigns[campaignID];
        c.beneficiary = beneficiary;
        c.fundingGoal = goal;
    }

		function contribute(uint campaignID) public payable {
				Campaign storage c = campaigns[campaignID];
				// creates a new temporary memory struct, initialised with the given values
				// and copies it over to storage.
				// Note that you can also use Funder(msg.sender, msg.value) to initialise.
				c.funders[c.numFunders++] = Funder({addr: msg.sender, amount: msg.value});
				c.amount += msg.value;
		}

		function checkGoalReached(uint campaignID) public returns (bool reached) {
				Campaign storage c = campaigns[campaignID];
				if (c.amount < c.fundingGoal)
						return false;
				uint amount = c.amount;
				c.amount = 0;
				c.beneficiary.transfer(amount);
				return true;
		}
```

### Mapping types

Mapping types use the syntax `mapping(KeyType => ValueType)` and variables of mapping type are declared using the syntax `mapping(KeyType => ValueType) VariableName`. The `KeyType` can be any built-in value type, `bytes`, `string`, or any contract or enum type. Other user-defined or complex types, such as mappings, structs or array types are not allowed. `ValueType`can be any type, including mappings, arrays and structs.

link for reference Iterable mappings etc. : [https://docs.soliditylang.org/en/v0.8.15/types.html#reference-types](https://docs.soliditylang.org/en/v0.8.15/types.html#reference-types)

### Gas Optimization

Advance Solidity

![Untitled](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/4477aae2-fbb6-4787-8ff9-83d159abd76b/Untitled.png)

### Style Guide

[https://docs.soliditylang.org/en/v0.8.16/style-guide.html](https://docs.soliditylang.org/en/v0.8.16/style-guide.html)
