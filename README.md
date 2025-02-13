# For cairo0 python

In python VM we can have hints (including inputs)

To compile: `cairo-compile program.cairo --output compiled.json`

To test locally: `cairo-run --program compiled.json --program_input input.json --layout recursive --print_output`

# For cairo0 rust

(Custom hints are not supported yet, including inputs)

To compile: `cairo-compile program.cairo --output compiled.json`
To test locally: `cairo-run --program compiled.json --layout recursive --print_output`
