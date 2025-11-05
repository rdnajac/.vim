-- nv.lazy.file.setup()
require('nvim.lazy.file').setup()
return {
  { 'LazyVim/LazyVim' },
  {
    'folke/lazydev.nvim',
    opts = {
      library = {
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
        { path = 'LazyVim', words = { 'LazyVim' } },
        { path = 'snacks.nvim', words = { 'Snacks' } },
        -- { path = "lazy.nvim", words = { "LazyVim" } },
        { path = 'mini.diff', words = { 'MiniDiff' } },
        { path = 'nvim', words = { 'nv' } },
      },
    },
  },
}
