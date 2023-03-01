## **DeFi Oracle Introduction**

Currently, smart contract values such as pricing and configuration cannot update themselves. To execute its contract logic, external data is sometimes required during execution. This is typically done with the following methods.

1. Through externally owned accounts. We can calculate the price based on the reserves of these accounts.
2. Use an oracle, which is maintained by someone or even yourself. With external data updated periodically. ie., price, interest rate, anything.

For example, in Uniswap V2, they provide the current price of the asset, which is used to determine the relative value of the asset being traded and thus execute the trade.

Following the figure, ETH price is the external data. The smart contract obtains it from Uniswap V2.

We know the formula x \* y = k in a typical AMM. x ( ETH price in this case) = k / y.

So we take a look at the Uniswap V2 WETH/USDC trading pair contract. At this address 0xb4e16d0168e52d35cacd2c6185b44281ec28c9dc.

At the time of publication we see the following reserve values:

WETH: 33,906.6145928 USDC: 42,346,768.252804

Formula: Applying the x \* y = k formula will yield the price for each ETH:

42,346,768.252804 / 33,906.6145928 = 1248.9235

(Market prices may differ from the calculated price by a few cents. In most cases, this refers to a trading fee or a new transaction that affects the pool. This variance can be skimmed with skim()1.)

Oracle Price Manipulation Attack Modes
Most common attack modes:

Alter the oracle address

Root cause: lack of verification mechanism
For example: Rikkei Finance
Through flash loans, an attacker can drain liquidity, resulting in wrong pricing information in an oracle.

This is most often seen in attackers calling these functions. GetPrice、Swap、StackingReward, Transfer(with burn fee), etc.
Root cause: Protocols using unsafe/compromised oracles, or the oracle did not implement time-weighted average price features.
Example: One Ring Finance
Protip-case 2: During code review ensure the functionbalanceOf()is well guarded.

DONE READING ABOUT DEFI HACK ORACLE EXAMPLES
