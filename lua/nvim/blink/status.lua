local get_providers = function(mode)
  mode = (mode or vim.api.nvim_get_mode().mode):sub(1, 1)
  local cmp_mode = ({ c = 'cmdline', t = 'terminal' })[mode] or 'default'
  local ok, lib = pcall(require, 'blink.cmp.sources.lib')
  if not ok or not lib then
    return {}
  end
  local enabled = vim.tbl_keys(lib.get_enabled_providers(cmp_mode))
  table.sort(enabled)
  return enabled
end

return function()
  return ' '
    .. vim
      .iter(ipairs(get_providers()))
      :map(function(_, provider) return nv.icons.blink[provider] end)
      :join(' / ')
end
-- cond = function() return package.loaded['blink.cmp'] and vim.fn.mode():sub(1, 1) == 'i' end, },
