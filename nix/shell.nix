{
  inputs,
  pkgs,
  self,
  ...
}:

let
  inherit (self.checks.${pkgs.system}) pre-commit;
in
pkgs.mkShell {
  nativeBuildInputs = with pkgs; [
    dart-sass
    gobject-introspection
    meson
    ninja
    pkg-config
    vala
    wrapGAppsHook4
  ];
  buildInputs =
    (with pkgs; [
      gtk4
      gtk4-layer-shell
      libadwaita
      libportal-gtk4
      networkmanager

      uncrustify
      vala-lint
    ])
    ++ (with inputs.astal.packages.${pkgs.system}; [
      astal4
      apps
      battery
      bluetooth
      hyprland
      io
      mpris
      network
      notifd
      tray
      wireplumber
    ]);

  shellHook =
    pre-commit.shellHook
    # bash
    + ''
      if [ ! -d build ]; then
          meson setup build
      fi
      PATH="build:''${PATH}"
    '';
}
