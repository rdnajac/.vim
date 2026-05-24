--- init.lua
vim.loader.enable()
vim.cmd([[so ~/.vim/vimrc]])
vim.cmd([[pa  snacks.nvim]])
_G.bt = Snacks.debug.backtrace
_G.dd = Snacks.debug.inspect
_G.fn = vim.fn
_G.nv = vim
  .iter(fn.readdir(vim.fs.joinpath(fn.stdpath('config'), 'lua', 'nvim')))
  :map(function(fname) return fn.fnamemodify(fname, ':r') end)
  :map(function(mname) return mname, require('nvim.' .. mname) end)
  :fold({}, rawset) -- inits an empty table and maps `nv[nvim.k] = v`

local status = nv.ui.status
nv.statusline = status.line
nv.winbar = function()
  return vim.api.nvim_get_current_win() ~= tonumber(vim.g.actual_curwin) and status.buffer()
    or status.render(status.buffer(), status.lsp(), ' ' .. status.treesitter()) .. '%#WinBar# '
end

vim.schedule(function()
  vim.diagnostic.config(nv.diagnostic.opts)
  -- enable servers found in the after directory
  vim.lsp.enable(nv.lsp.servers())
end)
