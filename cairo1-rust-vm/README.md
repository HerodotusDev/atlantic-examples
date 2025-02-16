# For Cairo 1

## Setup

1. Install scarb: https://docs.swmansion.com/scarb/ (using asdf)

2. Build: `scarb build`

3. Our output file is `target/release/cairo1.sierra.json`

4. To test locally: `scarb cairo-run --arguments-file input.cairo1.json`
    1. You should see: `Run completed successfully, returning [485, 486]`
    2. That means that output is at addresses `[485, 486)`
    3. You can run `scarb cairo-run --arguments-file input.cairo1.json --print-full-memory` to see the memory and from there find the actual output

## Get your API key

To get your API key, navigate to [https://www.herodotus.cloud/](https://www.herodotus.cloud/), log in and go to API KEYS section.

## Send to Atlantic

When sending to Atlantic, you can choose where your proof should be verified. For more details check [L1 Proof Verification](http://docs.herodotus.cloud/atlantic/steps/l1-proof-verification) and [L2 Proof Verification](http://docs.herodotus.cloud/atlantic/steps/l2-proof-verification).

You can track your queries in Atlantic > Console section.

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
