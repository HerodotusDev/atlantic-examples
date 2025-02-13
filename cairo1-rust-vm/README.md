# Cairo 1

1. Install scarb: https://docs.swmansion.com/scarb/ (using asdf)

2. Build: `scarb build`

3. Our output file is `target/release/cairo1.sierra.json`

4. To test locally: `scarb cairo-run --arguments-file input.cairo1.json`
   1. You should see: `Run completed successfully, returning [485, 486]`
   2. That means that output is at addresses `[485, 486)`
   3. You can run `scarb cairo-run --arguments-file input.cairo1.json --print-full-memory` to see the memory and from there find the actual output
