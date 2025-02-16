# L1 Verification - Starknet Contracts

This directory contains Ethereum contract that stores verified fibonacci numbers. It demonstrates how to interact with Sharp verifier and how to write a contract that uses proofs verified on Ethereum.

### Usage

You can use already deployed contract: `0x1b5e3FcceBBED5b8fEa3B12476F98F415E1e2675`

Following functions are available:

-   `proveFibonacci(uint32 index, uint32 value, bool cairoVersion)` - Save fibonacci number that was verified with Sharp verifier.
-   `getFibonacci(uint32 index) -> uint32` - Get fibonacci number that was saved in verifiable way by `proveFibonacci`.

> **Note**: For `proveFibonacci` function to succeed, you need to send Atlantic query with program from `cairo0-python-vm` or `cairo1-rust-vm` and `result=PROOF_VERIFICATION_ON_L1`.

### Deploying yourself

1. Set up `.env` using `.env.example` template

2. Run `forge build`

3. Run `source .env;forge script script/FibonacciRegistry.s.sol --rpc-url $RPC_URL --broadcast --verify --chain 11155111 --etherscan-api-key $ETHERSCAN_API_KEY`

### Proving fibonacci

If you have already sent proof for verification on Ethereum, you can prove fibonacci number in the contract using:

For cairo0:
`source .env;cast send --rpc-url $RPC_URL --private-key $PRIVATE_KEY 0x1b5e3FcceBBED5b8fEa3B12476F98F415E1e2675 "proveFibonacci(uint32,uint32,bool)" 10 55 false`

For cairo1:
`source .env;cast send --rpc-url $RPC_URL --private-key $PRIVATE_KEY 0x1b5e3FcceBBED5b8fEa3B12476F98F415E1e2675 "proveFibonacci(uint32,uint32,bool)" 17 1597 true`

Where calldata consists of `index`, `value` and `cairo_version` (false for cairo0, true for cairo1).
