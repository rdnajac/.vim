vim.lsp.enable('luals')

return {
  {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    opts = { ensure_installed = { 'lua-language-server', 'stylua' } },
  },
  {
    'folke/lazydev.nvim',
    config = function(_, opts)
      require('config.lazy.devpatch')
      require('lazydev.config').setup(opts)
    end,
  },
}
