{ pkgs, self, ... }:

let
  inherit (self.checks.${pkgs.system}) pre-commit;
in
pkgs.mkShell {
  nativeBuildInputs =
    pre-commit.enabledPackages
    ++ (with pkgs; [
      cargo
      rustc

      clippy
      rust-analyzer

      cargo-deny
      cargo-edit
      cargo-expand
      cargo-msrv
      cargo-udeps

      blueprint-compiler
      dart-sass
      gobject-introspection
      pkg-config
      wrapGAppsHook4
    ]);
  buildInputs = with pkgs; [
    gtk4
    gtk4-layer-shell
  ];

  env = {
    RUST_BACKTRACE = 1;
    RUST_SRC_PATH = pkgs.rustPlatform.rustLibSrc;
  };

  inherit (pre-commit) shellHook;
}
