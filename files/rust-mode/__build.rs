// build.rs -*- mode: rustic -*-
/*
 * `(+snippet-expand "llm-header")`
 * https://doc.rust-lang.org/cargo/reference/build-scripts.html
*/

// //-- imports (only build-dependencies)
extern crate bindgen;

use std::{env, path::PathBuf};

// --------------------------------------------------
fn main() {
    let out_dir = env::var("OUT_DIR").unwrap();

    // C compilation
    cc::Build::new()
        .include("c_src")
        .file("c_src/simple.c")
        .compile("simple");

    // bindgen
    let bindings = bindgen::Builder::default()
        .header("wrapper.h")
        .parse_callbacks(Box::new(bindgen::CargoCallbacks::new()))
        .generate()
        .expect("unable to generate bindings");

    let out_buf = PathBuf::from(out_dir);

    bindings
        .write_to_file(out_buf.join("bindings.rs"))
        .expect("couldn't write bindings");

    bindings
        .write_to_file("bindings.rs")
        .expect("couldn't write local bindings");

}
