material_design_dir = join_paths('MaterialDesign', 'svg')
material_design_outdir = join_paths(meson.current_build_dir(), 'symbolic', 'apps')

icons = custom_target(
  'material-icons',
  input: files(
    join_paths(material_design_dir, 'power-settings.svg'),
  ),
  output: '@BASENAME@-symbolic.svg', # Cannot skip specifying.
  command: [
    'mkdir', '-p', material_design_outdir,
    '&&',
    # Cannot use @OUTPUT@ as that holds a full path.
    'cp', '@INPUT@', join_paths(material_design_outdir, '@BASENAME@-symbolic.svg'),
  ],
)
