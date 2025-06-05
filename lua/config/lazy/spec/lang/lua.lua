vim.lsp.enable('luals')

return {
  {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    opts = { ensure_installed = { 'lua-language-server', 'stylua' } },
  },
}
