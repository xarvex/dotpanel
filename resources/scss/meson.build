scss = custom_target(
  'scss',
  input: 'main.scss',
  output: 'style.css',
  command: [find_program('sass'), '@INPUT@', '@OUTPUT@'],
  depend_files: files(
    'bar.scss',
  ),
)
