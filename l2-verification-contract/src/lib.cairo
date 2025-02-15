use integrity::{
    calculate_bootloaded_fact_hash, SHARP_BOOTLOADER_PROGRAM_HASH, VerifierConfiguration,
};

#[starknet::interface]
trait IFibonacciRegistry<TContractState> {
    // Get the nth fibonacci number if it was verified.
    fn get_fibonacci(self: @TContractState, n: u32) -> u32;

    // Prove given fibonacci number with proof verified by Integrity.
    // cairo_version: true if cairo1, false if cairo0.
    fn prove_fibonacci(ref self: TContractState, index: u32, value: u32, cairo_version: bool);
}

// Calculate fact hash for cairo1 programs bootloaded in cairo0 by Atlantic.
fn calculate_cairo1_fact_hash(
    program_hash: felt252, input: Span<felt252>, output: Span<felt252>,
) -> felt252 {
    let CAIRO1_BOOTLOADER_PROGRAM_HASH =
        0x288ba12915c0c7e91df572cf3ed0c9f391aa673cb247c5a208beaa50b668f09;
    let OUTPUT_CONST = 0x49ee3eba8c1600700ee1b87eb599f16716b0b1022947733551fde4050ca6804;

    let mut bootloader_output = array![
        0x0, OUTPUT_CONST, 0x1, input.len().into() + output.len().into() + 5, program_hash, 0x0,
    ];
    bootloader_output.append(output.len().into());
    for x in output {
        bootloader_output.append(*x);
    };
    bootloader_output.append(input.len().into());
    for x in input {
        bootloader_output.append(*x);
    };

    // All programs sent to Sharp are bootloaded (second time in this case).
    calculate_bootloaded_fact_hash(
        SHARP_BOOTLOADER_PROGRAM_HASH, CAIRO1_BOOTLOADER_PROGRAM_HASH, bootloader_output.span(),
    )
}

// Return Integrity configuration variables for Sharp proofs.
// Layout depends on what built-ins your program uses.
fn get_config(layout: felt252) -> (VerifierConfiguration, u32) {
    // This config depends on prover configuration that was used to generate the proof.
    // If you are proving using custom Stone configuration, you need to adjust those settings.
    // Configuration below is for Sharp proofs with configuration used by Atlantic.
    let config = VerifierConfiguration {
        layout, hasher: 'keccak_160_lsb', stone_version: 'stone6', memory_verification: 'relaxed',
    };
    let SECURITY_BITS = 96;
    (config, SECURITY_BITS)
}

// Calculate fact hash for specific cairo0 program - cairo0-python-vm/program.cairo
fn get_cairo0_fact_hash(index: u32, value: u32) -> felt252 {
    // Program hash is constant for the compiled program (inputs/outputs don't change program hash).
    // You can see the program hash in Atlantic query metadata at "program_hash" key.
    let CAIRO0_PROGRAM_HASH =
        0x407908712e70dd914b006062d8d70bd8aeae06bcfc973cbd4309e7f3a2e825b; // depends on program you verify

    // Sharp bootloader outputs [1, output.len() + 2, program_hash, ...output],
    // for which Integrity has utility function `calculate_bootloaded_fact_hash`.
    // By default inputs in cairo0 are private, so our program exposes both index and value in the
    // output.
    calculate_bootloaded_fact_hash(
        SHARP_BOOTLOADER_PROGRAM_HASH, CAIRO0_PROGRAM_HASH, [index.into(), value.into()].span(),
    )
}

// Calculate fact hash for specific cairo1 program - cairo1-rust-vm/src/lib.cairo
fn get_cairo1_fact_hash(index: u32, value: u32) -> felt252 {
    // Cairo1 program hash is present in Atlantic query metadata at **"child_program_hash"** key.
    // IMPORTANT: In cairo1 query, program_hash refers to the program hash of the bootloader which
    //            is constant, your actual program hash is present in its output which is shown
    //            at "child_program_hash" key.
    let CAIRO1_PROGRAM_HASH = 0x1b2f325bf7c611b8cf643eed5451102df4128cb17d621dad15e2cdb9d3e3afb;

    calculate_cairo1_fact_hash(CAIRO1_PROGRAM_HASH, [index.into()].span(), [value.into()].span())
}

#[starknet::contract]
mod FibonacciRegistry {
    use super::*;
    use starknet::storage::{
        Map, StoragePointerReadAccess, StoragePointerWriteAccess, StoragePathEntry,
    };
    use integrity::{Integrity, IntegrityWithConfig};

    #[storage]
    struct Storage {
        fibonacci_values: Map<u32, Option<u32>>,
    }

    #[derive(Drop, starknet::Event)]
    struct FibonacciProven {
        index: u32,
        value: u32,
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    pub enum Event {
        FibonacciProven: FibonacciProven,
    }

    #[abi(embed_v0)]
    impl FibonacciRegistryImpl of IFibonacciRegistry<ContractState> {
        fn get_fibonacci(self: @ContractState, n: u32) -> u32 {
            self.fibonacci_values.entry(n).read().expect('Not found')
        }

        fn prove_fibonacci(ref self: ContractState, index: u32, value: u32, cairo_version: bool) {
            let (config, security_bits) = get_config('recursive');

            let fact_hash = if cairo_version {
                get_cairo1_fact_hash(index, value)
            } else {
                get_cairo0_fact_hash(index, value)
            };

            // Integrity package provides functions for easier checking if given fact is verified.
            let integrity = Integrity::new();
            let is_valid = integrity
                .with_config(config, security_bits)
                .is_fact_hash_valid(fact_hash);
            assert(is_valid, 'Proof not verified');

            // This is specific to your application.
            // After assert above, you are sure that integrity verified the program.
            self.fibonacci_values.entry(index).write(Option::Some(value));
            self.emit(Event::FibonacciProven(FibonacciProven { index, value }));
        }
    }
}

#[cfg(test)]
mod test {
    use super::*;

    #[test]
    fn test_get_cairo1_fact_hash() {
        let hash = get_cairo1_fact_hash(17, 1597);
        assert(
            hash == 0x5c596ac545e4ca0e8c459ff2af206315e49ec121fdc101d35b5ab038b823923,
            'Cairo1 fact hash mismatch',
        );
    }

    #[test]
    fn test_get_cairo0_fact_hash() {
        let hash = get_cairo0_fact_hash(10, 55);
        assert(
            hash == 0x1c446d13efc5a3a16387eeec2c9347e9fd44e195b178916e1bd27c0a18220f1,
            'Cairo0 fact hash mismatch',
        );
    }
}
