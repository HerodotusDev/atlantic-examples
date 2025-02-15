%builtins output pedersen range_check bitwise
func main(
    output_ptr: felt*,
    pedersen_ptr: felt*,
    range_check_ptr: felt*,
    bitwise_ptr: felt*
) -> (
    output_ptr: felt*,
    pedersen_ptr: felt*,
    range_check_ptr: felt*,
    bitwise_ptr: felt*
) {
    alloc_locals;

    local input = 11;

    assert output_ptr[0] = input;
    let res = fib(0, 1, input);
    assert output_ptr[1] = res;

    return (
        output_ptr=&output_ptr[2],
        pedersen_ptr=pedersen_ptr,
        range_check_ptr=range_check_ptr,
        bitwise_ptr=bitwise_ptr
    );
}

func fib(a: felt, b: felt, n: felt) -> felt {
    if (n == 0) {
        return a;
    }

    return fib(a = b, b = a + b, n = n - 1);
}
