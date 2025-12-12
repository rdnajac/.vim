-- local plugins = vim.iter(nv.submodules()):map(require):map(nv.fn.ensure_list):flatten():totable()
local plugins = vim.iter(nv.submodules()):map(require):map(nv.fn.ensure_list):flatten():totable()

table.insert(plugins, {
  'folke/lazydev.nvim',
  opts = {
    library = {
      -- PERF: unnecessary witH `$VIMRUNTIME/lua/uv/_meta.lua`
      -- { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      { path = 'LazyVim', words = { 'LazyVim' } },
      { path = 'snacks.nvim', words = { 'Snacks' } },
      { path = 'lazy.nvim', words = { 'LazyVim' } },
      { path = 'mini.nvim', words = { 'Mini.*' } },
      { path = 'nvim', words = { 'nv' } },
    },
  },
})

return plugins
