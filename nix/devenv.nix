{
  inputs,
  lib,
  pkgs,
}:

{
  devenv.root =
    let
      devenvRoot = builtins.readFile inputs.devenv-root.outPath;
    in
    # If not overridden (/dev/null), --impure is necessary.
    lib.mkIf (devenvRoot != "") devenvRoot;

  name = "dotpanel";

  packages =
    (with pkgs; [
      codespell
      uncrustify
      vala-language-server
      vala-lint
      vale-ls
      vscode-langservers-extracted

      dart-sass
      gobject-introspection
      gtk4
      gtk4-layer-shell
      libportal-gtk4
      meson
      networkmanager
      ninja
      pkg-config
      wrapGAppsHook4
    ])
    ++ (with inputs.astal.packages.${pkgs.system}; [
      apps
      astal4
      battery
      hyprland
      io
      mpris
      network
      notifd
      tray
      wireplumber
    ]);

  enterShell = ''
    if [ ! -d build ]; then
        meson setup build
    fi
    PATH="build:''${PATH}"
  '';

  languages = {
    nix.enable = true;
    vala.enable = true;
  };

  pre-commit.hooks = {
    deadnix.enable = true;
    flake-checker.enable = true;
    nixfmt-rfc-style.enable = true;
    statix.enable = true;
  };
}
