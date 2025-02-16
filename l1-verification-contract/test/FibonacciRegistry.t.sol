// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import {getCairo0FactHash, getCairo1FactHash} from "../src/FibonacciRegistry.sol";

contract FibonacciRegistryTest is Test {
    function test_factHashCairo0() pure public {
        uint256 factHash = uint256(getCairo0FactHash(10, 55));
        assertEq(factHash, 0xfabc599614bbd9752bd58d365c7434f7f61792a6fc2ffbd3a0256636915c2c58);
    }

    function test_factHashCairo1() pure public {
        uint256 factHash = uint256(getCairo1FactHash(17, 1597));
        assertEq(factHash, 0x11927cde0c1b71ac1b00a024e2cd8a60d0fe0e1c71c227dbd1c07960de5bf777);
    }
}
