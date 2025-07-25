local source_icons = require('nvim.icons').blink_src

local M = {}

function M.source_status()
  local ok, sources = pcall(require, 'blink.cmp.sources.lib')
  if not ok then
    vim.notify('blink.cmp.sources.lib not found', vim.log.levels.ERROR)
    return ''
  end

  local out = {}
  local enabled = sources.get_enabled_providers('default')
  for name in pairs(sources.get_all_providers()) do
    -- FIXME:
    local icon = source_icons[name] or icons.kinds[name:sub(1, 1):upper() .. name:sub(2)] or ''
    if enabled[name] then
      table.insert(out, icon)
    end
  end
  return table.concat(out, ' ')
end

return M
