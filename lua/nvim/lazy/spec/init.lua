-- HACK: capture the `LazyVim` global
_G.LazyVim = require('lazyvim.util')

-- HACK: capture the `LazyFile` event
-- require('lazyvim.util.plugin').lazy_file()
LazyVim.plugin.lazy_file()
LazyVim.format.setup()
-- LazyVim.news.setup()
-- LazyVim.root.setup()
-- LazyVim.track("colorscheme")
-- dd('tokyonight did config?')
-- require("tokyonight").load()
-- LazyVim.cmp.

return {
  'tpope/vim-abolish',
  'tpope/vim-apathy',
  'tpope/vim-fugitive',
  'tpope/vim-repeat',
  'tpope/vim-surround',
  'tpope/vim-tbone',
  'tpope/vim-unimpaired',
  { 'nvim-lua/plenary.nvim', lazy = true },
  { 'folke/lazy.nvim', version = false },
  { 'LazyVim/LazyVim', version = false },
  { import = 'lazyvim.plugins.coding' },
  { import = 'lazyvim.plugins.extras.editor.dial' },
  { import = 'lazyvim.plugins.extras.editor.mini-files' },
  { import = 'lazyvim.plugins.extras.util.mini-hipatterns' },
  { import = 'lazyvim.plugins.extras.ui.treesitter-context' },
}
