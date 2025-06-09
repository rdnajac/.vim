vim.lsp.enable('vimls')

return {
  {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    opts = { ensure_installed = { 'vim-language-server' } },
  },
  -- iterate over the plugins defined in vim.g.vim_plugins
  -- and add them to the spec if they are enabled for nvim
  unpack(vim.tbl_map(
    function(name)
      return { name }
    end,
    vim.tbl_filter(function(name)
      return vim.g.vim_plugins[name] == 1
    end, vim.tbl_keys(vim.g.vim_plugins))
  )),
}
