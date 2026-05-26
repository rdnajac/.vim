local status = require('nvim.status')

return function()
  return vim.api.nvim_get_current_win() ~= tonumber(vim.g.actual_curwin) and status.buffer()
    or status.render(status.buffer(), status.lsp(), ' ' .. status.treesitter()) .. '%#WinBar# '
end
