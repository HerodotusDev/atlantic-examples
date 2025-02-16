// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {FibonacciRegistry} from "../src/FibonacciRegistry.sol";

contract FibonacciRegistryScript is Script {
    FibonacciRegistry public fibonacciRegistry;

    function setUp() public {}

    function run() public {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        fibonacciRegistry = new FibonacciRegistry();

        vm.stopBroadcast();
    }
}
