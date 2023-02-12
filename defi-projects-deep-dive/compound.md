# Compound Deep Dive

## Background

Interest rates fill the gap between people with surplus assets they can’t use, and people without assets (that have a productive or investment use); trading the time value assets benefits both parties, and creates non-zero-sum wealth. For blockchain assets, two major flaws exist today:

- Borrowing mechanism are extremely limited, which contributes to mispriced assets (e.g. “scamcoins” with unfathomable valuations, because there’s no way to short them).
- Blockchain assets have negative yield, resulting from significant storage costs and risks (both on-exchange and off-exchange), without natural interests rates to offset those costs. This contribute to volatility, as holding is disincentivized.

## Compound Protocol

money markets, which are pools of assets with algorithmically derived interest rates, based on the supply and demand for the asset. Suppliers (and Borrowers) of an asset interact directly with the protocol, earning (and paying) a floating interest rate, without having to negotiate terms such as maturity, interest rate, or collateral with a peer or counterparty.

### Supplying Assets

Unlike an exchange or peer-to-peer platform, where a users’ assets are matched and lent to another user, the Compound protocol aggregates the supply of each user; when a user supplies an asset, it becomes a fungible resource, This approach offer significantly more liquidity than direct lending; users can withdraw their assets at any time, without waiting for specific loan to mature.

Assets supplied to a market are represented by an ERC-20 token “cToken”, which entitles the owner to an increasing quantity of underlying asset.

**Example**, you supplied 1000 DAI on 1 Jan 2020, and APY 10% constant throughout 2020.

on January 2020, after you have deposited 1000 DAI, you will be given 1000 cDAI. rate 1 : 1

on January 2021, after one year, your 1000 cDAI will now increase in value by 10%. the new exchange rate 1 : 1.1. your 1000 cDAI now worth and redeemable for 1100 DAI.

### Borrowing Assets

Compound allow users to frictionlessly borrow from the protocol, using cTokens as collateral.

**\*\***\*\***\*\***\*\*\*\***\*\***\*\***\*\***Collateral Value**\*\***\*\***\*\***\*\*\*\***\*\***\*\***\*\***

Assets held by the protocol (represented by ownership of a cToken) are used as collateral to borrow from protocol. each market has collateral factor, ranging from 0 to 1.

The sum of the value of an accounts underlying token balances, multiplied by the collateral factors, equal a user’s **borrowing capacity**.

\***\*\*\*\*\*\*\***\*\*\***\*\*\*\*\*\*\***Why users want to borrow?\***\*\*\*\*\*\*\***\*\*\***\*\*\*\*\*\*\***

Leveraged Long ETH/or any other token (from 0xMacro Contract Book Club)

![Untitled](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/1bc17faf-1210-48b0-9523-8e3653f390b8/Untitled.png)

or Short ETH/any other token

![Untitled](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/95fc9ca9-eb3a-4c62-a8db-978fe070729d/Untitled.png)

### Risk & Liquidation

If the value of an account’s borrowing outstanding exceeds their borrowing capacity, a portion of the outstanding borrowing may be repaid in exchange for the user’s cToken collateral, at the current market price minus a **liquidation discount;**

The proportion eligible to be closed, a \***\*\*\*\*\***\*\*\*\*\***\*\*\*\*\***close factor\***\*\*\*\*\***\*\*\*\*\***\*\*\*\*\***, is the portion of the borrowed asset that can be repaid, and ranges from 0 to 1, such as 25%.

### Interest Rate Model

Interest rate model based on supply and demand of each money market. When demand low, interest rates should be low, and vise versa when demand is high.

The utilization ratio **U** for each market **a** unifies supply and demand into a single variable:

$$
U_a = Borrows_a/(Cash_a + Borrows_a)
$$

The demand curve is codified through governance and is expressed as a function of utilization. As an example, borrowing interest rates may resemble the following:

$$
Borrowing Interest Rate _a = 2.5   percent + U_a * 20 percent
$$

The interest rate earned by suppliers is implicit, and is equal to the borrowing interest rate, multiplied by the utilization rate.

### cToken Contracts

each money market is structured as a smart contract that implements the ERC-20 token specs. User’s balances are represented as cToken balances; user can `mint(uint amountUnderlying)` cTokens by supplying assets to the market, or `redeem(uint amount)` cTokens for the underlying asset. The price (exchange rate) between cTokens and the underlying asset increases over time, as interest is accrued by borrowers of the asset, and is equal to:

$$
exchangeRate = (underlyingBalance + totalBorrowBalance_a - reserves_a) / cTokenSupply_a
$$

### Interest Rate Mechanics

The history of each interest rate, for each money market, is captured by an **Interest Rate Index**, which is calculated each time an interest rate changes, resulting from a user minting, redeeming, borrowing, repaying or liquidating the asset.

**\*\***\*\***\*\***\*\***\*\***\*\***\*\***Market Dynamics**\*\***\*\***\*\***\*\***\*\***\*\***\*\***

Interest Rate Index for the asset is updated to compound the interest since prior index, using the interest for the period, denominated by r \* t, calculated using a per-block interest rate:

$$
Index_{a,n} = Index_{a, (n-1)} * (1+r*t)
$$

The market’s total borrowing outstanding is updated to include interest accrued since the last index:

$$
totalBorrowBalance_{a,n} = totalBorrowBalance_{a,(n-1)} * (1+r*t)
$$

And a portion of the accrued interest is retained (set aside) as reservers, determined by a \***\*\*\*\*\*\*\***\*\*\*\*\***\*\*\*\*\*\*\***reserveFactor,\***\*\*\*\*\*\*\***\*\*\*\*\***\*\*\*\*\*\*\*** ranging from 0 to 1 :

$$
reserves_a = reserves_{a,(n-1)} + totalBorrowBalance_{a,(n-1)} * (r * t * reserveFactor)
$$

### Borrowing

A user who wishes to borrow and who has sufficient balances stored in Compound may call `borrow(uint amount)` on the relevant cToken contract. This function call checks the user’s account value, and given sufficient collateral, will update the user’s borrow balance, transfer the tokens to the user’s Ethereum address, and update the money market’s floating interest rate.

Borrows accrue interest in the exact same fashion as balance interest was calculated in previous section. a borrower has the right to repay an outstanding loan at any time, by calling `repayBorrow(uint amount)` which repays the outstanding balance.

### Liquidation

public function `liquidate(address target, address collateralAsset, address borrowAsset, uint closeAmount)` can be called, which exchanges the invoking user’s asset for the borrowers’ collateral, at a slightly better than market price.
