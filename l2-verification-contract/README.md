# L2 Verification - Starknet Contracts

This directory contains cairo1 contract that stores verified fibonacci numbers. It demonstrates how to interact with Integrity verifier and how to write a contract that uses proofs verified on Starknet.

### Usage

You can use already deployed contract: `0x064834e92197cd65f3d71a34abcc88c77f54022f6a4a016e75d60f9aeed172bf`.

Following functions are available:

-   `prove_fibonacci(index: u32, value: u32, cairo_version: bool)` - Save fibonacci number that was verified with Integrity verifier.
-   `get_fibonacci(index: u32) -> u32` - Get fibonacci number that was saved in verifiable way by `prove_fibonacci`.

> **Note**: For `prove_fibonacci` function to succeed, you need to send Atlantic query with program from `cairo0-python-vm` or `cairo1-rust-vm` and `result=PROOF_VERIFICATION_ON_L2`.

### Deploying yourself

1. Modify `snfoundry.toml` to use your account

2. `scarb build`

3. `sncast declare --contract-name FibonacciRegistry`

4. `sncast deploy --class-hash 0x05201fccd044d68b97462bc75b9e8a186a672533e6341a7f5604e98a3c0c30c7`

### Proving fibonacci

If you have already sent proof for verification on Starknet, you can prove fibonacci number in the contract using:

For cairo0:
`sncast invoke --contract-address 0x064834e92197cd65f3d71a34abcc88c77f54022f6a4a016e75d60f9aeed172bf --function prove_fibonacci --calldata "10 55 0"`

For cairo1:
`sncast invoke --contract-address 0x064834e92197cd65f3d71a34abcc88c77f54022f6a4a016e75d60f9aeed172bf --function prove_fibonacci --calldata "17 1597 1"`

Where `--calldata` consists of `index`, `value` and `cairo_version` (0 or 1).
