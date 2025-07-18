local kinds = require('snacks.picker.config.defaults').defaults.icons.kinds
local sources = require('blink.cmp.sources.lib')

local source_icons = {
  buffer = ' ',
  cmdline = ' ',
  env = '$ ',
  lazydev = '󰒲 ',
  lsp = ' ',
  omni = ' ',
  path = ' ',
  snippets = kinds.Snippet,
}

local M = {}

function M.source_status()
  local out = {}
  local enabled = sources.get_enabled_providers('default')
  --- @type table<string, boolean>
  for name in pairs(sources.get_all_providers()) do
    local icon = source_icons[name] or kinds[name:sub(1, 1):upper() .. name:sub(2)] or ''
    if enabled[name] then
      table.insert(out, icon)
    end
  end
  return table.concat(out, ' ')
end

print(M.source_status())

return M
