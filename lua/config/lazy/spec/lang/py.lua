vim.lsp.enable('ruff')

return {
  {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    opts = { ensure_installed = { 'ruff' } },
  },
}
