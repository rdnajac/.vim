--- @type vim.lsp.Config
return {
  -- cmd = { 'r-languageserver' }, -- launcher script from mason installation
  cmd = {
    'R',
    '--vanilla',
    '--quiet',
    '--no-echo',
    '--no-save',
    '-e',
    'languageserver::run()',
  },
  filetypes = { 'r', 'rmd', 'quarto' },
  root_markers = { '.Rprofile', '.git' },
}
