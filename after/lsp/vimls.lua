--- @type vim.lsp.Config
return {
  cmd = { 'vim-language-server', '--stdio' },
  filetypes = { 'vim' },
  root_markers = { '.git' },
  init_options = {
    isNeovim = true,
    iskeyword = '@,48-57,_,192-255,-#',
    vimruntime = '',
    runtimepath = '',
    diagnostic = { enable = false },
    indexes = {
      runtimepath = true,
      gap = 100,
      count = 3,
      projectRootPatterns = { 'runtime', 'nvim', '.git', 'autoload', 'plugin' },
    },
    suggest = { fromVimruntime = true, fromRuntimepath = true },
  },
}
-- TODO: should this display settings in checkhealth lsp?
