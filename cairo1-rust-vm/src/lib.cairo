// Notice:
// Your program must take felt252 array as input and output
fn main(input: Array<felt252>) -> Array<felt252> {
    assert(input.len() == 1, 'Invalid input length');
    let n: u32 = (*input[0]).try_into().expect('Invalid input');
    array![fib(n).into()]
}

fn fib(mut n: u32) -> u32 {
    let mut a: u32 = 0;
    let mut b: u32 = 1;
    while n != 0 {
        n = n - 1;
        let temp = b;
        b = a + b;
        a = temp;
    };
    a
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_fib() {
        assert_eq!(fib(10), 55);
    }
}
