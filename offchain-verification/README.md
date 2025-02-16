# Offchain Verification

There are multiple offchain verifiers but we will use [Swiftness](https://github.com/iosis-tech/swiftness) which is a rust implementation.

### Usage

If you have already sent a query to Atlantic, you can download the proof using `download_proof.bash` script.

```bash
./download_proof.bash <atlantic-query-id>
```

Then to perform verification:

1. `cd swiftness/cli`
2. `cargo run --release --no-default-features --features recursive,keccak_160_lsb,stone6 -- --proof ../../proof.json`
