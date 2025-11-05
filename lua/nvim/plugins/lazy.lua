-- add LazyVim to the package path for development
-- vim.schedule(function()
vim.pack.add({
  vim.fn['git#url']('LazyVim/LazyVim'),
}, { load = false })
-- end)

return {
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
}
