# For cairo0 python vm

> **🤓 Note:** In Python VM we can have hints and inputs
>
> **🐌 However** Python VM is **SLOW**, use Rust VM if possible.

1. Install cairo-lang https://docs.cairo-lang.org/quickstart.html

   1. `python3.9 -m venv ~/cairo_venv`
   2. `source ~/cairo_venv/bin/activate`
   3. Install gmp
      1. `sudo apt install -y libgmp3-dev` on Linux
      2. `brew install gmp` on Mac
   4. `pip3 install cairo-lang`

2. To compile: `cairo-compile program.cairo --output compiled.json`

3. To test locally: `cairo-run --program compiled.json --program_input input.json --layout starknet_with_keccak --print_output`
