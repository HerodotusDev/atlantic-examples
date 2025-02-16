// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

interface ISharpFactRegistry {
    function isValid(bytes32 fact) external view returns (bool);
}

interface IFibonacciRegistry {
    // Get the nth fibonacci number if it was verified.
    function getFibonacci(uint32 n) external view returns (uint32);

    // Prove given fibonacci number with proof verified by Sharp.
    // cairo_version: true if cairo1, false if cairo0.
    function proveFibonacci(uint32 index, uint32 value, bool cairoVersion) external;
}

struct SavedUint32 {
    bool present;
    uint32 value;
}

// Calculate fact hash for cairo1 programs bootloaded in cairo0 by Atlantic.
function calculateCairo1FactHash(uint256 programHash, uint256[] memory input, uint256[] memory output) pure returns (bytes32) {
    uint256 CAIRO1_BOOTLOADER_PROGRAM_HASH = 0x288ba12915c0c7e91df572cf3ed0c9f391aa673cb247c5a208beaa50b668f09;
    uint256 OUTPUT_CONST = 0x49ee3eba8c1600700ee1b87eb599f16716b0b1022947733551fde4050ca6804;

    uint256[] memory bootloaderOutput = new uint256[](8 + input.length + output.length);
    bootloaderOutput[0] = 0x0;
    bootloaderOutput[1] = OUTPUT_CONST;
    bootloaderOutput[2] = 0x1;
    bootloaderOutput[3] = input.length + output.length + 5;
    bootloaderOutput[4] = programHash;
    bootloaderOutput[5] = 0x0;
    bootloaderOutput[6] = output.length;
    for (uint256 i = 0; i < output.length; i++) {
        bootloaderOutput[7 + i] = output[i];
    }
    bootloaderOutput[7 + output.length] = input.length;
    for (uint256 i = 0; i < input.length; i++) {
        bootloaderOutput[8 + output.length + i] = input[i];
    }

    bytes32 outputHash = keccak256(abi.encodePacked(bootloaderOutput));
    return keccak256(abi.encode(CAIRO1_BOOTLOADER_PROGRAM_HASH, outputHash));
}

// Calculate fact hash for specific cairo0 program - cairo0-python-vm/program.cairo
function getCairo0FactHash(uint32 index, uint32 value) pure returns (bytes32) {
    // Program hash is constant for the compiled program (inputs/outputs don't change program hash).
    // You can see the program hash in Atlantic query metadata at "program_hash" key.
    uint256 CAIRO0_PROGRAM_HASH = 0x407908712e70dd914b006062d8d70bd8aeae06bcfc973cbd4309e7f3a2e825b;

    // By default inputs in cairo0 are private, so our program exposes both index and value in the
    // output.
    uint256[] memory output = new uint256[](2);
    output[0] = index;
    output[1] = value;

    bytes32 outputHash = keccak256(abi.encodePacked(output));
    return keccak256(abi.encode(CAIRO0_PROGRAM_HASH, outputHash));
}

// Calculate fact hash for specific cairo1 program - cairo1-rust-vm/src/lib.cairo
function getCairo1FactHash(uint32 index, uint32 value) pure returns (bytes32) {
    // Cairo1 program hash is present in Atlantic query metadata at **"child_program_hash"** key.
    // IMPORTANT: In cairo1 query, program_hash refers to the program hash of the bootloader which
    //            is constant, your actual program hash is present in its output which is shown
    //            at "child_program_hash" key.
    uint256 CAIRO1_PROGRAM_HASH = 0x1b2f325bf7c611b8cf643eed5451102df4128cb17d621dad15e2cdb9d3e3afb;

    uint256[] memory input = new uint256[](1);
    input[0] = index;

    uint256[] memory output = new uint256[](1);
    output[0] = value;

    return calculateCairo1FactHash(CAIRO1_PROGRAM_HASH, input, output);
}

contract FibonacciRegistry is IFibonacciRegistry {
    uint256 constant PROGRAM_HASH = 0x0;
    ISharpFactRegistry constant sharpFactRegistry = ISharpFactRegistry(0x07ec0D28e50322Eb0C159B9090ecF3aeA8346DFe);

    mapping(uint32 => SavedUint32) public fibonacci_values;

    event FibonacciProven(uint32 index, uint32 value);

    function getFibonacci(uint32 n) public view returns (uint32) {
        require(fibonacci_values[n].present, "Not found");
        return fibonacci_values[n].value;
    }

    function proveFibonacci(uint32 index, uint32 value, bool cairoVersion) public {
        // Realistically, in your contract you will only support one cairo version that you want
        // to use for proving.
        bytes32 factHash = cairoVersion ? getCairo1FactHash(index, value) : getCairo0FactHash(index, value);
        bool isValid = sharpFactRegistry.isValid(factHash);
        require(isValid, "Proof not verified");

        // This is specific to your application.
        // After require above, you are sure that Sharp verified the program.
        fibonacci_values[index] = SavedUint32({present: true, value: value});
        emit FibonacciProven(index, value);
    }
}
