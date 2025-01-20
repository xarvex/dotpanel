{
  dart-sass,
  gobject-introspection,
  gtk4,
  gtk4-layer-shell,
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
      libportal-gtk4
      networkmanager
    ]
    ++ (with astal.packages.${system}; [
      astal4
      apps
      battery
      hyprland
      io
      mpris
      network
      notifd
      tray
      wireplumber
    ]);
}
