# L2 Verification - Starknet Contracts

You can either use already deployed contract: `0x064834e92197cd65f3d71a34abcc88c77f54022f6a4a016e75d60f9aeed172bf `.

Or deploy yourself:

1. Modify `snfoundry.toml` to use your account

2. `scarb build`

3. `sncast declare --contract-name FibonacciRegistry --fee-token eth`

4. `sncast deploy --class-hash 0x05201fccd044d68b97462bc75b9e8a186a672533e6341a7f5604e98a3c0c30c7 --fee-token eth`

## To prove fibonacci

If you have already sent proof for verification on Starknet, you can prove fibonacci number in this contract using:

For cairo0:
`sncast invoke --contract-address 0x064834e92197cd65f3d71a34abcc88c77f54022f6a4a016e75d60f9aeed172bf --function prove_fibonacci --calldata "10 55 0" --fee-token eth`

For cairo1:
`sncast invoke --contract-address 0x064834e92197cd65f3d71a34abcc88c77f54022f6a4a016e75d60f9aeed172bf --function prove_fibonacci --calldata "17 1597 1" --fee-token eth`
