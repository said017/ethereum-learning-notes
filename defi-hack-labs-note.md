## **DeFi Oracle Introduction**

Currently, smart contract values such as pricing and configuration cannot update themselves. To execute its contract logic, external data is sometimes required during execution. This is typically done with the following methods.

1. Through externally owned accounts. We can calculate the price based on the reserves of these accounts.
2. Use an oracle, which is maintained by someone or even yourself. With external data updated periodically. ie., price, interest rate, anything.

For example, in Uniswap V2, they provide the current price of the asset, which is used to determine the relative value of the asset being traded and thus execute the trade.

Following the figure, ETH price is the external data. The smart contract obtains it from Uniswap V2.

We know the formula x \* y = k in a typical AMM. x ( ETH price in this case) = k / y.

So we take a look at the Uniswap V2 WETH/USDC trading pair contract. At this address 0xb4e16d0168e52d35cacd2c6185b44281ec28c9dc.
