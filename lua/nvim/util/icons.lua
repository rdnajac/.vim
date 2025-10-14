--   package.preload['nvim-web-devicons'] = function()
--     require('mini.icons').mock_nvim_web_devicons()
--     return package.loaded['nvim-web-devicons']
--   end
local icons = {
  src = { -- blink sources
    buffer = ' ',
    cmdline = ' ',
    copilot = ' ',
    env = ' ',
    lazydev = '󰒲 ',
    lsp = ' ',
    omni = ' ',
    path = ' ',
    snippets = ' ',
    cmp_r = ' ',
  },
  mason = {
    package_installed = '✓',
    package_pending = '➜',
    package_uninstalled = '✗',
  },
  copilot = {
    Error = { ' ', 'DiagnosticError' },
    Inactive = { ' ', 'MsgArea' },
    Warning = { ' ', 'DiagnosticWarn' },
    Normal = { ' ', 'Special' },
  },
  separators = { -- useful in statuslines
    component = {
      angle = { left = '', right = '' },
      rounded = { left = '', right = '' },
    },
    section = {
      angle = { left = '', right = '' },
      rounded = { left = '', right = '' },
    },
  },
}

local snacks_icons = require('snacks.picker.config.defaults').defaults.icons
local M = vim.tbl_deep_extend('force', {}, icons, snacks_icons)

-- add an inverted lookup table for kinds
for i, name in ipairs(vim.lsp.protocol.SymbolKind) do
  M.kinds[i] = M.kinds[name]
end

local mini_icon_keys = {
  'directory',
  'extension',
  'file',
  'filetype',
  'os',
}

local function get_mini_icon(_, key, lookup)
  if not _G.MiniIcons then
    return ' '
  end
  return _G.MiniIcons.get(key, lookup) or ' '
end

for _, category in ipairs(mini_icon_keys) do
  local function _get_mini_icon(_, lookup)
    return get_mini_icon(_, category, lookup)
  end

  M[category] = setmetatable({}, {
    __index = _get_mini_icon,
    __call = _get_mini_icon,
  })
end

return M
