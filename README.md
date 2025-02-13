# For cairo1

Install scarb: https://docs.swmansion.com/scarb/ (using asdf)

Build: `scarb --release build`

Our output file is `target/release/cairo1.sierra.json`

To test locally: `scarb --release cairo-run "[[10]]" --print-full-memory`
`Run completed successfully, returning [485, 486]` means that output is at addresses `[485, 486)`

# For cairo0 python

In python VM we can have hints (including inputs)

To compile: `cairo-compile program.cairo --output compiled.json`

To test locally: `cairo-run --program compiled.json --program_input input.json --layout recursive --print_output`

# For cairo0 rust

(Custom hints are not supported yet, including inputs)

To compile: `cairo-compile program.cairo --output compiled.json`
To test locally: `cairo-run --program compiled.json --layout recursive --print_output`
