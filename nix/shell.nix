{ pkgs, self, ... }:

let
  inherit (self.checks.${pkgs.system}) pre-commit;
in
pkgs.mkShell {
  nativeBuildInputs = with pkgs; [
    cargo
    rustc

    blueprint-compiler
    dart-sass
    gobject-introspection
    pkg-config
    wrapGAppsHook4
  ];
  buildInputs =
    pre-commit.enabledPackages
    ++ (with pkgs; [
      gtk4
      gtk4-layer-shell

      clippy
      rust-analyzer

      cargo-deny
      cargo-edit
      cargo-expand
      cargo-msrv
      cargo-udeps
    ]);

  env = {
    RUST_BACKTRACE = 1;
    RUST_SRC_PATH = pkgs.rustPlatform.rustLibSrc;
  };

  inherit (pre-commit) shellHook;
}
