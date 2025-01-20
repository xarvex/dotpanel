subdir('scss')

sources += import('gnome').compile_resources(
  meson.project_name(),
  'com.gitlab.xarvex.dotfyls.dotpanel.gresource.xml',
  dependencies: [scss],
  source_dir: meson.current_build_dir(),
)
