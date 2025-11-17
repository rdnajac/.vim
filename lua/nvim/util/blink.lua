-- blink wrappers
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

---@type nv.status.Component
M.status = {
  function()
    return vim.tbl_map(function(src)
      return nv.icons.src[src] or ' '
    end, M.get_providers())
  end,
  cond = function()
    return package.loaded['blink.cmp'] and vim.fn.mode():sub(1, 1) == 'i'
  end,
}

return M
