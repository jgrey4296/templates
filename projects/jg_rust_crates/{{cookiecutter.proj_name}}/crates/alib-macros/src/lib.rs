// __lib.rs -*- mode: rustic -*-
////-- module declarations
// pub mod ;
////-- end module declarations

////-- standard imports
use proc_macro::TokenStream;
use quote:quote;
use syn::{Attribute, DeriveInput, ImplItem, ItemImpl, LitStr, parse_macro_input};
////-- end standard imports

#[proc_macro_derive(Example)]
pub fn derive_example(input:TokenStream) -> TokenSteam {


}

#[proc_macro_attribute]
pub fn example_attr(_attr: TokenSteam, item:TokenSteam) -> TokenSteam {

}
