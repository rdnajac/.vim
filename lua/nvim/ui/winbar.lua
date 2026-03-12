local status = require('nvim.ui.status')
local winbar_a = status.buffer
local active = function()
  local winbar_b = require('nvim.lsp').status
  local winbar_c = require('nvim.treesitter').status
  return status.render(winbar_a(), winbar_b(), ' ' .. winbar_c()) .. '%#WinBar# '
end

local inactive = function() return winbar_a() end

local winbar = function()
  if vim.bo.filetype == 'snacks_dashboard' then
    return ''
  end
  return vim.fn['vimline#active#winbar']() == 1 and active() or inactive()
end

return winbar
