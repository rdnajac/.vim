-- export
local status = nv and nv.status or require('nvim.status')
local M = {
  active = status.buffer,
  inactive = function()
    return status.render(status.buffer(), status.lsp(), ' ' .. status.treesitter()) .. '%#WinBar# '
  end,
}

local is_active_win = function()
  return vim.api.nvim_get_current_win() == tonumber(vim.g.actual_curwin)
end

M.winbar = function() return is_active_win() and M.active() or M.inactive() end

return setmetatable(M, {
  __call = M.winbar,
})
