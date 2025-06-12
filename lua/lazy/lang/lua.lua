langsetup({ { 'lua-language-server', 'luals' }, 'stylua' })

return {
  {
    'folke/lazydev.nvim',
    ft = 'lua',
    cmd = 'LazyDev',
    opts = {
      -- stylua: ignore
      library = {
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
        { path = 'LazyVim',            words = { 'LazyVim' } },
        { path = 'snacks.nvim',        words = { 'Snacks' } },
        { path = 'lazy.nvim',          words = { 'LazyVim' } },
      },
    },
    config = function(_, opts)
      -- HACK: fix lsp name mismatch
      require('lazy.devpatch')
      require('lazydev.config').setup(opts)
    end,
  },
}
