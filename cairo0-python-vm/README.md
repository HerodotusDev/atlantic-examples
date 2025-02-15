# For Cairo0 Python VM

> **🤓 Note:** In Python VM we can have hints and inputs
>
> **🐌 However** Python VM is **SLOW**, use Rust VM if possible.

## Setup

1. Install cairo-lang https://docs.cairo-lang.org/quickstart.html

    1. `python3.9 -m venv ~/cairo_venv`
    2. `source ~/cairo_venv/bin/activate`
    3. Install gmp
        1. `sudo apt install -y libgmp3-dev` on Linux
        2. `brew install gmp` on Mac
    4. `pip3 install cairo-lang`

2. To compile: `cairo-compile program.cairo --output compiled.json`

3. To test locally: `cairo-run --program compiled.json --program_input input.json --layout starknet_with_keccak --print_output`

## Get your API key

TODO

## Send to Atlantic

When sending to Atlantic, you can choose where your proof should be verified. For more details check [L1 Proof Verification](http://docs.herodotus.cloud/atlantic/steps/l1-proof-verification) and [L2 Proof Verification](http://docs.herodotus.cloud/atlantic/steps/l2-proof-verification).

## L2 Verification query

To send query for L2 verification to Atlantic, run:

```bash
bash ./send_query.sh <your_api_key> PROOF_VERIFICATION_ON_L2
```

And check out how [Starknet contract](../l2-verification-contract/README.md) works.

## L1 Verification query

To send query for L1 verification to Atlantic, run:

```bash
bash ./send_query.sh <your_api_key> PROOF_VERIFICATION_ON_L1
```

And check out how [Ethereum contract](../l1-verification-contract/README.md) works.
