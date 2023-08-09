extern crate proc_macro;
use proc_macro::TokenStream;

#[proc_macro_attribute]
pub fn need_more_tests(attr: TokenStream, item: TokenStream) -> TokenStream {
    let s = attr.to_string();

    if s == "" {
        println!(" ************ WARNING ************ ");
        println!(" * This function needs nore tests * ");
        println!(" ********** END WARNING ********** ");
    } else {
        println!(" ************ WARNING ************ ");
        println!(" * This function needs nore tests * ");
        println!(" * Because {} * ", s);
        println!(" ********** END WARNING ********** ");
    }
    item
}
