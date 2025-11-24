-- blink wrappers
local M = {}

M.get_providers = function(mode)
  mode = (mode or vim.api.nvim_get_mode().mode):sub(1, 1)
  local cmp_mode = ({
    i = 'default',
    c = 'cmdline',
    t = 'terminal',
  })[mode] or 'default'
  return vim.tbl_keys(require('blink.cmp.sources.lib').get_enabled_providers(cmp_mode))
end

-- stylua: ignore
M.icons = {
  buffer    = '',
  cmdline   = '',
  copilot   = '',
  env       = '',
  lazydev   = '󰒲',
  lsp       = '',
  omni      = '',
  path      = '',
  snippets  = '',
}

local provider_icons = function()
  return vim
    .iter(M.get_providers())
    :map(function(src)
      -- return nv.icons.src[src] or ' '
      return M.icons[src] or ' '
    end)
    :join(' ')
end

---@type nv.status.Component
M.status = {
  provider_icons,
  cond = function()
    return package.loaded['blink.cmp'] and vim.fn.mode():sub(1, 1) == 'i'
  end,
}

return M
