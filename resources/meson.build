subdir('icons')
subdir('scss')

sources += import('gnome').compile_resources(
  meson.project_name(),
  'org.codeberg.xarvex.dotpanel.gresource.xml',
  dependencies: icons + [scss],
  source_dir: meson.current_build_dir(),
)
