![](/.github/banner.png)

# Atlantic Examples

This repository contains example cairo programs to use with Atlantic.
It also has example contracts for using the verified execution on-chain.

## Cairo Programs

Atlantic allows you to write any program in Cairo and generate proof for its execution. That proof can be later verified on Ethereum (L1), Starknet (L2) or off-chain. Depending on your needs, you can choose 3 different Cairo version and VM configurations:

-   [cairo1 Rust VM](cairo1-rust-vm/README.md) - Higher level language (similar to Rust), easier to write, but less performant.

-   [cairo0 Rust VM](cairo0-rust-vm/README.md) - Lower lever (close to direct VM instructions), best performance, but lack of hints support.

-   [cairo0 Python VM](cairo0-python-vm/README.md) - Supports custom hints, but slower than Rust VM.

## Contracts

Asking Atlantic to verify your proof on-chain.

> **Note:** You have to first develop and send your program to Atlantic, as shown in the [examples above](#cairo-programs).

-   [L1 Verification - Ethereum Contracts](l1-verification/README.md)

-   [L2 Verification - Starknet Contracts](l2-verification/README.md)

## Offchain

Using the proof from Atlantic offchain, by yourself.

> **Note:** You have to first develop and send your program to Atlantic, as shown in the [examples above](#cairo-programs).

-   [Offchain](offchain/README.md)
