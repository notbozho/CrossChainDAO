# CrossChain DAO

> Modular DAO system built in Solidity using the Diamond Proxy standard with cross-chain proposal execution through LayerZero.

## Overview

CrossChain DAO is a governance protocol that allows on-chain voting and proposal execution across multiple blockchains. Built with upgradeability, security, and a readable, modular design in mind.

---

## Features

> ✨ _This project was built from scratch using Foundry, OpenZeppelin, and the Diamond Proxy pattern to demonstrate deep understanding of Solidity architecture, upgradeability, and cross-chain messaging._

| Feature                                                                 | Description                                                                     |
| ----------------------------------------------------------------------- | ------------------------------------------------------------------------------- |
| **Governance System**                                                   | Token-based voting using OpenZeppelin's `ERC20Votes` with checkpointing support |
| **Diamond Proxy [(EIP-2535)](https://eips.ethereum.org/EIPS/eip-2535)** | Modular, upgradeable architecture using facets                                  |
| **Cross-Chain Execution**                                               | Proposal execution across chains using LayerZero                                |
| **Shared Expandable Storage**                                           | Storage is shared across all facets, allowing state expansion                   |
| **Upgradeable Logic**                                                   | Add/replace facets without redeploying the protocol                             |

---

## Usage

In order to run tests, create a `.env` file with:

- public key:
- deployer private key:
- rpc urls for Polygon and Base
- [lz endpoint addresses and ids](https://docs.layerzero.network/v2/deployments/deployed-contracts) for Polygon and Base
  _You can copy `.env.example`_

### Build Contracts

```bash
forge build
```

### Run Tests

```bash
forge test -vv --ffi
```

### Format Code

```bash
forge fmt
```
