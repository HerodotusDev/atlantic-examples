# For cairo1

Install scarb: https://docs.swmansion.com/scarb/ (using asdf)

Build: `scarb --release build`

Our output file is `target/release/cairo1.sierra.json`

To test locally: `scarb --release cairo-run "[[10]]" --print-full-memory`
`Run completed successfully, returning [485, 486]` means that output is at addresses `[485, 486)`
