{
  dart-sass,
  gobject-introspection,
  gtk4,
  gtk4-layer-shell,
  lib,
  libadwaita,
  libportal-gtk4,
  meson,
  networkmanager,
  ninja,
  pkg-config,
  stdenv,
  system,
  vala,
  wrapGAppsHook4,

  astal,
}:

stdenv.mkDerivation {
  name = "dotpanel";

  src = ../.;

  nativeBuildInputs = [
    dart-sass
    gobject-introspection
    meson
    ninja
    pkg-config
    vala
    wrapGAppsHook4
  ];

  buildInputs =
    [
      gtk4
      gtk4-layer-shell
      libadwaita
      libportal-gtk4
      networkmanager
    ]
    ++ (with astal.packages.${system}; [
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

  meta = {
    description = "dotpanel";
    homepage = "https://codeberg.org/xarvex/dotpanel";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ xarvex ];
    mainProgram = "dotpanel";
    platforms = lib.platforms.linux;
  };
}
