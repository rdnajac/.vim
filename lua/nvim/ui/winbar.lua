local status = require('nvim.ui.status')

local inactive = status.buffer

local active = function()
  return status.render(status.buffer(), status.lsp(), ' ' .. status.treesitter()) .. '%#WinBar# '
end

local is_active_win = function()
  return vim.api.nvim_get_current_win() == tonumber(vim.g.actual_curwin)
end

local winbar = function()
  if is_active_win() then
    return active()
  end
    return inactive()
end

vim.schedule(function()
  vim.o.winbar = '%{%v:lua.nv.ui.winbar()%}'
end)

return winbar
