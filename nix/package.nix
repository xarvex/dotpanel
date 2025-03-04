{
  gobject-introspection,
  gtk4,
  gtk4-layer-shell,
  lib,
  rustPlatform,
  wrapGAppsHook4,
  blueprint-compiler,
  dart-sass,
  pkg-config,
}:

let
  manifest = (lib.importTOML ../Cargo.toml).package;
in
rustPlatform.buildRustPackage {
  pname = manifest.name;
  inherit (manifest) version;

  nativeBuildInputs = [
    blueprint-compiler
    dart-sass
    gobject-introspection
    pkg-config
    wrapGAppsHook4
  ];
  buildInputs = [
    gtk4
    gtk4-layer-shell
  ];

  src = ../.;
  cargoLock.lockFile = ../Cargo.lock;

  meta = {
    inherit (manifest) description;
    homepage = manifest.repository;
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ xarvex ];
    mainProgram = manifest.name;
    platforms = lib.platforms.linux;
  };
}
