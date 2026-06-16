nv.on('UIEnter', function()
  nv.ui['2'].setup()
  vim.cmd.colorscheme('tokyonight')
  vim.o.winbar = '%{%v:lua.nv.ui.winbar()%}'
  -- vim.fn['chromatophore#setup']()
end)

return nv.submodule('nvim.ui')
