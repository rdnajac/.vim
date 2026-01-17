local M = {}

M.spec = {
  -- { 'folke/lazy.nvim' },
  -- { 'LazyVim/LazyVim' },
  {
    'folke/lazydev.nvim',
    opts = {
      library = {
        -- PERF: no longer necessary witH `$VIMRUNTIME/lua/uv/_meta.lua`
        -- { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
        -- { path = 'LazyVim', words = { 'LazyVim' } },
        { path = 'snacks.nvim', words = { 'Snacks' } },
        -- { path = 'lazy.nvim', words = { 'LazyVim' } },
        { path = 'mini.nvim', words = { 'Mini.*' } },
        { path = 'nvim/util', words = { 'nv' } },
      },
    },
  },
}

return M
