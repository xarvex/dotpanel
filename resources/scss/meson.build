scss = custom_target(
  'scss',
  input: 'main.scss',
  output: 'style.css',
  command: [find_program('sass'), '@INPUT@', '@OUTPUT@'],
  depend_files: files(
    '_adw.scss',
    '_bar.scss',
    '_components.scss',
    '_gtk.scss',
  ),
)
