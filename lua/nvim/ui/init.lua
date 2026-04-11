vim.schedule(function()
  vim.o.statusline = [[%{%v:lua.nv.ui.status.line()%}]]
  vim.o.winbar = [[%{%v:lua.nv.ui.winbar()%}]]
end)

return {
  colorscheme = require('nvim.ui.tokyonight'),
  icons = require('nvim.ui.icons'),
  status = require('nvim.ui.status'),
  winbar = require('nvim.ui.winbar'),
  spinner = function() ---@return string
    local spinner = { '⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏' }
    return spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
  end,
}
