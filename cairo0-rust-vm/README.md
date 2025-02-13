# For cairo0 rust vm

> **⚠️ Note:** In Rust VM it's not possible to have hints nor inputs! Use Python VM if you need hints or inputs.
>
> **🏎️ However** Rust VM is **FAST**, use it if possible.

1. Install cairo-lang https://docs.cairo-lang.org/quickstart.html

   1. `python3.9 -m venv ~/cairo_venv`
   2. `source ~/cairo_venv/bin/activate`
   3. Install gmp
      1. `sudo apt install -y libgmp3-dev` on Linux
      2. `brew install gmp` on Mac
   4. `pip3 install cairo-lang`

2. To compile: `cairo-compile program.cairo --output compiled.json`

3. To test locally: `cairo-run --program compiled.json --layout starknet_with_keccak --print_output`
