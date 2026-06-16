local winbar = function()
  local status = require('nvim.ui.status')
  if vim.api.nvim_get_current_win() == tonumber(vim.g.actual_curwin) then
    return status.render(status.buffer(), status.lsp(), ' ' .. status.treesitter()) .. '%#WinBar# '
    -- local parts = {
    --   status.buffer(),
    --   status.lsp(),
    --   ' ' .. status.treesitter(),
    -- }
    -- return status.render(parts) .. '%#WinBar# '
  end
  return status.buffer()
end

return winbar
