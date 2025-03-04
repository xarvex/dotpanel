use std::{env, path::Path, process::Command};

fn main() {
    compile_sass("resources/styles/main.scss", "resources/style.css");

    glib_build_tools::compile_resources(
        &[
            "resources",
            &format!("{}/resources", env::var("OUT_DIR").unwrap()),
        ],
        "resources/resources.gresource.xml",
        "com.xarvex.dotpanel.gresource",
    );
}

fn compile_sass<P: AsRef<Path>>(style: P, target: &str) {
    let style = style.as_ref();

    println!(
        "cargo:rerun-if-changed={}",
        style
            .parent()
            .map(|p| p.to_str().unwrap())
            .unwrap_or(&env::var("CARGO_MANIFEST_DIR").unwrap())
    );

    let out_dir = env::var("OUT_DIR").unwrap();
    let out_dir = Path::new(&out_dir);

    let output = Command::new("sass")
        .arg(style)
        .arg(out_dir.join(target))
        .output()
        .unwrap();

    assert!(
        output.status.success(),
        "sass failed with exit status {} and stderr:\n{}",
        output.status,
        String::from_utf8_lossy(&output.stderr)
    );
}
