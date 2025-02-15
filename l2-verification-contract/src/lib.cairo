use integrity::{calculate_bootloaded_fact_hash, SHARP_BOOTLOADER_PROGRAM_HASH};

#[starknet::interface]
trait IFibonacciRegistry<TContractState> {
    fn get_fibonacci(self: @TContractState, n: u32) -> u32;
    fn prove_fibonacci(ref self: TContractState, index: u32, value: u32, cairo_version: bool);
}

fn get_cairo0_program_hash(index: u32, value: u32) -> felt252 {
    let CAIRO0_PROGRAM_HASH = 0x407908712e70dd914b006062d8d70bd8aeae06bcfc973cbd4309e7f3a2e825b;
    // sharp bootloader outputs [1, output.len() + 2, program_hash, ...output]
    // for which integrity has utility function calculate_bootloaded_fact_hash
    // by default inputs in cairo0 are private, so our program exposes both index and value in output
    calculate_bootloaded_fact_hash(
        SHARP_BOOTLOADER_PROGRAM_HASH, CAIRO0_PROGRAM_HASH, [index.into(), value.into()].span()
    )
}

fn get_cairo1_program_hash(index: u32, value: u32) -> felt252 {
    let CAIRO1_PROGRAM_HASH = 0x1b2f325bf7c611b8cf643eed5451102df4128cb17d621dad15e2cdb9d3e3afb;
    // cairo1 bootloader outputs: [
    //   0x0,
    //   0x49ee3eba8c1600700ee1b87eb599f16716b0b1022947733551fde4050ca6804,
    //   0x1,
    //   input.len() + output.len() + 5
    //   0x1,
    //   program_hash,
    //   0x0,
    //   output.len(),
    //   ...output
    //   input.len(),
    //   ...input
    // ]
    // which is then bootloaded 2nd time with sharp bootloader
    let cairo1_output = [
        0x0,
        0x49ee3eba8c1600700ee1b87eb599f16716b0b1022947733551fde4050ca6804,
        0x1,
        0x7, // output.len() = 1, input.len() = 1
        CAIRO1_PROGRAM_HASH,
        0x0,
        0x1,
        value.into(),
        0x1,
        index.into(),
    ];
    let CAIRO1_BOOTLOADER_PROGRAM_HASH = 0x288ba12915c0c7e91df572cf3ed0c9f391aa673cb247c5a208beaa50b668f09;
    calculate_bootloaded_fact_hash(
        SHARP_BOOTLOADER_PROGRAM_HASH, CAIRO1_BOOTLOADER_PROGRAM_HASH, cairo1_output.span()
    )
}

// 0x05be1e03ae550825aed78a99c9048c41aee73b2e8cab199a732b175abf54cd8a
#[starknet::contract]
mod FibonacciRegistry {
    use super::{IFibonacciRegistry, get_cairo0_program_hash, get_cairo1_program_hash};
    use starknet::storage::{Map, StoragePointerReadAccess, StoragePointerWriteAccess, StoragePathEntry};
    use integrity::{Integrity, IntegrityWithConfig, VerifierConfiguration};

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
            let config = VerifierConfiguration {
                layout: 'recursive',
                hasher: 'keccak_160_lsb',
                stone_version: 'stone6',
                memory_verification: 'relaxed',
            };
            let SECURITY_BITS = 96;

            let fact_hash = if cairo_version {
                get_cairo1_program_hash(index, value)
            } else {
                get_cairo0_program_hash(index, value)
            };

            let integrity = Integrity::new();
            let is_valid = integrity.with_config(config, SECURITY_BITS).is_fact_hash_valid(fact_hash);
            assert(is_valid, 'Proof not verified');

            self.fibonacci_values.entry(index).write(Option::Some(value));
            self.emit(Event::FibonacciProven(FibonacciProven { index, value }));
        }
    }
}

#[cfg(test)]
mod test {
    use super::*;

    #[test]
    fn test_get_cairo1_program_hash() {
        let hash = get_cairo1_program_hash(17, 1597);
        assert(hash == 0x5c596ac545e4ca0e8c459ff2af206315e49ec121fdc101d35b5ab038b823923, 'Hash mismatch');
    }

    #[test]
    fn test_get_cairo0_program_hash() {
        let hash = get_cairo0_program_hash(10, 55);
        assert(hash == 0x1c446d13efc5a3a16387eeec2c9347e9fd44e195b178916e1bd27c0a18220f1, 'Hash mismatch');
    }
}