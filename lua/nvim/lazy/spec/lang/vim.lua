vim.lsp.enable('vimls')
return {
  {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    opts = { ensure_installed = { 'vim-language-server' } },
  },
  -- 'tpope/vim-scriptease'
  -- 'vuciv/golf',
}
