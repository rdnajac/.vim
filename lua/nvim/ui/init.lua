local M = {
  colorscheme = require('nvim.ui.tokyonight'),
  icons = require('nvim.ui.icons'),
  status = require('nvim.ui.status'),
}

vim.schedule(function()
  vim.o.statusline = [[%{%v:lua.nv.ui.status.line()%}]]
  vim.o.winbar = [[%{%v:lua.nv.ui.winbar()%}]]
end)

M.winbar = function()
  if vim.bo.filetype == 'snacks_dashboard' then
    return ''
  end
  if vim.api.nvim_get_current_win() ~= tonumber(vim.g.actual_curwin) then
    return M.status.buffer()
  end
  local a = M.status.buffer
  local b = M.status.lsp
  local c = M.status.treesitter
  return M.status.render(a(), b(), ' ' .. c()) .. '%#WinBar# '
end

return M
