# L1 Verification - Starknet Contracts

This directory contains Ethereum contract that stores verified fibonacci numbers. It demonstrates how to interact with Sharp verifier and how to write a contract that uses proofs verified on Ethereum.

### Usage

You can use already deployed contract: TODO

Following functions are available:

-   `proveFibonacci(uint32 index, uint32 value, bool cairoVersion)` - Save fibonacci number that was verified with Sharp verifier.
-   `getFibonacci(uint32 index) -> uint32` - Get fibonacci number that was saved in verifiable way by `proveFibonacci`.

> **Note**: For `proveFibonacci` function to succeed, you need to send Atlantic query with program from `cairo0-python-vm` or `cairo1-rust-vm` and `result=PROOF_VERIFICATION_ON_L1`.

### Deploying yourself

TODO

### Proving fibonacci

If you have already sent proof for verification on Ethereum, you can prove fibonacci number in the contract using:

For cairo0:
TODO

For cairo1:
TODO

Where TODO consists of `index`, `value` and `cairo_version` (0 or 1).
