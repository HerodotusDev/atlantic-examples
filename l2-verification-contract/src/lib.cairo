#[starknet::interface]
trait IFibonacciRegistry<TContractState> {
    fn get_fibonacci(self: @TContractState, n: u32) -> u32;
    fn prove_fibonacci(ref self: TContractState, index: u32, value: u32);
}

#[starknet::contract]
mod fibonacci_registry {
    use super::IFibonacciRegistry;
    use starknet::storage::{Map, StoragePointerReadAccess, StoragePointerWriteAccess, StoragePathEntry};
    use integrity::{Integrity, IntegrityWithConfig, calculate_bootloaded_fact_hash, SHARP_BOOTLOADER_PROGRAM_HASH, VerifierConfiguration};

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

    impl FibonacciRegistryImpl of IFibonacciRegistry<ContractState> {
        fn get_fibonacci(self: @ContractState, n: u32) -> u32 {
            self.fibonacci_values.entry(n).read().expect('Not found')
        }

        fn prove_fibonacci(ref self: ContractState, index: u32, value: u32) {
            let config = VerifierConfiguration {
                layout: 'recursive_with_poseidon',
                hasher: 'keccak_160_lsb',
                stone_version: 'stone6',
                memory_verification: 'relaxed',
            };
            let SECURITY_BITS = 96;
            let FIBONACCI_PROGRAM_HASH = 0x123;

            let fact_hash = calculate_bootloaded_fact_hash(
                SHARP_BOOTLOADER_PROGRAM_HASH, FIBONACCI_PROGRAM_HASH, [index.into(), value.into()].span()
            );

            let integrity = Integrity::new();
            let is_valid = integrity.with_config(config, SECURITY_BITS).is_fact_hash_valid(fact_hash);
            assert(is_valid, 'Proof not verified');

            self.fibonacci_values.entry(index).write(Option::Some(value));
            self.emit(Event::FibonacciProven(FibonacciProven { index, value }));
        }
    }
}

