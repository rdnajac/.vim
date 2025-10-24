local M = {}

M.get_providers = function(mode)
  mode = (mode or vim.api.nvim_get_mode().mode):sub(1, 1)

  local ok, sources = pcall(require, 'blink.cmp.sources.lib')
  if not ok or not sources then
    return {}
  end

  local cmp_mode = ({
    i = 'default',
    c = 'cmdline',
    t = 'terminal',
  })[mode] or 'default'

  return vim.tbl_keys(sources.get_enabled_providers(cmp_mode))
end

return M
