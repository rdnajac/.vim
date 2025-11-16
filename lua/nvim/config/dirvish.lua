  vim.g.dirvish_mode = [[:sort ,^.*[\/],]]

  local aug = vim.api.nvim_create_augroup('dirvish.nvim', {})

  vim.api.nvim_create_autocmd('FileType', {
    group = aug,
    pattern = 'dirvish',
    callback = function()
      -- XXX: dirvish doesn't support highlighting of icons yet
      require('nvim.icons.fs').render()
      vim.lsp.buf_attach_client(0, nv.lsp.dirvish.client_id)

      -- BUG: workaround for https://github.com/justinmk/vim-dirvish/issues/257
      vim.opt_local.listchars = vim.opt.listchars:get()
      vim.opt_local.listchars:remove('precedes')
    end,
  })
