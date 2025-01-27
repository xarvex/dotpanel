icons_dir = join_paths(meson.current_build_dir(), 'symbolic', 'apps')
material_design_dir = join_paths('MaterialDesign', 'svg')
codicons_dir = join_paths('vscode-codicons', 'src', 'icons')

# TODO: Find way to reduce code repetition.
icons = [
  custom_target(
    'material-design',
    input: files(
      join_paths(material_design_dir, 'power-settings.svg'),
      join_paths(material_design_dir, 'weather-sunset.svg'),
      join_paths(material_design_dir, 'weather-night.svg'),
      join_paths(material_design_dir, 'window-closed-variant.svg'),
    ),
    output: 'TEMPORARY-material-design',
    command: [
      'mkdir', '-p', icons_dir,
      '&&',
      'cp', '@INPUT0@', join_paths(icons_dir, 'md-@BASENAME0@-symbolic.svg'),
      '&&',
      'cp', '@INPUT1@', join_paths(icons_dir, 'md-@BASENAME1@-symbolic.svg'),
      '&&',
      'cp', '@INPUT2@', join_paths(icons_dir, 'md-@BASENAME2@-symbolic.svg'),
      '&&',
      'cp', '@INPUT3@', join_paths(icons_dir, 'md-@BASENAME3@-symbolic.svg'),
    ],
  ),
  custom_target(
    'codicons',
    input: files(
      join_paths(codicons_dir, 'coffee.svg'),
    ),
    output: 'TEMPORARY-codicons',
    command: [
      'mkdir', '-p', icons_dir,
      '&&',
      'cp', '@INPUT0@', join_paths(icons_dir, 'cod-@BASENAME0@-symbolic.svg'),
    ],
  ),
]
