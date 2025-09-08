# -*- mode: snippet -*-
# name  : test.mod
# uuid  : test.mod
# key   : test.mod
# group : jg
# --
// //--// tests
#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_sanity() {
        assert!(True);
    }


}
// //--// end tests
