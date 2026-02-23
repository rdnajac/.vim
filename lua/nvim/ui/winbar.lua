local winbar_a = ' %t'

local M = {
  active = function()
    local render = require('nvim.ui.status').render
    local winbar_b = require('nvim.lsp').status
    local winbar_c = require('nvim.treesitter').status
    return render(' %t', winbar_b(), ' ' .. winbar_c())
  end,

  inactive = function() return winbar_a end,
}

setmetatable(M, {
  __call = function()
    if vim.bo.filetype == 'snacks_dashboard' then
      return ''
    end
    local active = vim.fn['vimline#active#winbar']() == 1
    if active then
      return M.active()
    else
      return M.inactive()
    end
  end,
})
return M
