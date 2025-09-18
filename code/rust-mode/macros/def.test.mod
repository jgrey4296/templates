# -*- mode: snippet -*-
# name: test module
# key: testmod
# group: testing
# --
#[cfg(test)]
mod ${1:tests} {
    use super::*;

    #[test]
    fn ${2:test_name}() {
       $0
    }
}