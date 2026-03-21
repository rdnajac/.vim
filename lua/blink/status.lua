local icons = require('nvim.ui.icons').blink
local providers = function(mode)
  local ok, lib = pcall(require, 'blink.cmp.sources.lib')
  if not ok or not lib then
    return {}
  end
  mode = mode or vim.api.nvim_get_mode().mode
  local cmp_mode = ({ c = 'cmdline', t = 'terminal' })[mode:sub(1, 1)] or 'default'
  return lib.get_enabled_providers(cmp_mode)
end

local status = function()
  return vim.iter(providers()):map(function(k, _) return icons[k] .. ' ' end):join(' ')
end
