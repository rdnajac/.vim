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
  diff = { add = '▎', change = '▎', delete = '' },
  mason = {
    package_installed = '✓',
    package_pending = '➜',
    package_uninstalled = '✗',
  },
  -- TODO: add support for highlight groups
  copilot = {
    Error = { ' ', 'DiagnosticError' },
    Inactive = { ' ', 'MsgArea' },
    Warning = { ' ', 'DiagnosticWarn' },
    Normal = { ' ', 'Special' },
  },
  sep = {
    -- component and section separators appear as they
    -- would in lualine, where left/right refer to the
    -- side of the statusline they appear on, not the
    -- direction they point to (unlike the item separators)
    component = {
      angle = { left = '', right = '' },
      rounded = { left = '', right = '' },
    },
    section = {
      angle = { left = '', right = '' },
      rounded = { left = '', right = '' },
    },
    item = { left = ' ', right = ' ' },
  },
}

-- setmetatable(icons.src({
--   __call = function(_, key)
--     return icons.src[key]
--   end,
-- }))

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
  return _G.MiniIcons.get(key, lookup) .. ' ' or ' '
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

M.blink = function(src)
  return M.src[src] or ' '
end

return M
