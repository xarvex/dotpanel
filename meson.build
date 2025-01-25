project(
  'dotpanel',
  ['c', 'vala'],
  default_options: [ 'optimization=g' ],
)

add_project_arguments(
  '-Wno-discarded-qualifiers',
  '-Wno-unused-but-set-variable',
  '-Wno-unused-variable',
  language: 'c',
)

sources = []

subdir('resources')
subdir('src')

c = meson.get_compiler('c')

dependencies = [
  c.find_library('m', required: false),
  dependency('gio-unix-2.0'),
  dependency('glib-2.0'),
  dependency('gobject-2.0'),
  dependency('gtk4'),
  dependency('gtk4-layer-shell-0'),
  dependency('libadwaita-1'),
  dependency('libnm'),
  dependency('libportal'),
  dependency('astal-4-4.0'),
  dependency('astal-apps-0.1'),
  dependency('astal-battery-0.1'),
  dependency('astal-hyprland-0.1'),
  dependency('astal-io-0.1'),
  dependency('astal-mpris-0.1'),
  dependency('astal-network-0.1'),
  dependency('astal-notifd-0.1'),
  dependency('astal-tray-0.1'),
  dependency('astal-wireplumber-0.1'),
]

executable(
  'dotpanel',
  sources,
  dependencies: dependencies,
  install: true,
)
