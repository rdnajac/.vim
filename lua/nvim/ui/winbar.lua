local winbar_a = ' %t %m'
-- local winbar_a = require('nvim.ui.status').buffer

local active = function()
  local render = require('nvim.ui.status').render
  local winbar_b = require('nvim.lsp').status
  local winbar_c = require('nvim.treesitter').status
  return render(winbar_a, winbar_b(), ' ' .. winbar_c()) .. '%#WinBar# '
  -- .. nv.blink.status()
end

local inactive = function() return winbar_a end

local winbar = function()
  if vim.bo.filetype == 'snacks_dashboard' then
    return ''
  end
  return vim.fn['vimline#active#winbar']() == 1 and active() or inactive()
end

return winbar
