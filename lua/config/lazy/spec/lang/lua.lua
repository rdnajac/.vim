vim.lsp.enable('luals')

return {
  {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    opts = { ensure_installed = { 'lua-language-server', 'stylua' } },
  },
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
      require('config.lazy.devpatch')
      require('lazydev.config').setup(opts)
    end,
  },
}
