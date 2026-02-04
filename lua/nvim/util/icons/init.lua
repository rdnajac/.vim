local icons = {
  blink = {
    buffer = '',
    cmdline = '',
    copilot = '',
    env = '',
    lazydev = '󰒲',
    lsp = '',
    omni = '',
    path = '',
    snippets = '',
  },
  -- TODO: add support for highlight groups
  copilot = {
    Error = { ' ', 'DiagnosticError' },
    Inactive = { ' ', 'MsgArea' },
    Warning = { ' ', 'DiagnosticWarn' },
    Normal = { ' ', 'Special' },
  },
  diff = { add = '▎', change = '▎', delete = '' },
  mason = {
    emojis = {
      package_installed = '✅',
      package_pending = '➡️',
      package_uninstalled = '❌',
    },
    nerd = {
      package_installed = '✓',
      package_pending = '➜',
      package_uninstalled = '✗',
    },
    round = {
      package_installed = ' ',
      package_pending = ' ',
      package_uninstalled = ' ',
    },
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

local snacks_icons = {
  files = {
    enabled = true, -- show file icons
    dir = '󰉋 ',
    dir_open = '󰝰 ',
    file = '󰈔 ',
  },
  keymaps = {
    nowait = '󰓅 ',
  },
  tree = {
    vertical = '│ ',
    middle = '├╴',
    last = '└╴',
  },
  undo = {
    saved = ' ',
  },
  ui = {
    live = '󰐰 ',
    hidden = 'h',
    ignored = 'i',
    follow = 'f',
    selected = '● ',
    unselected = '○ ',
    -- selected = " ",
  },
  git = {
    enabled = true, -- show git icons
    commit = '󰜘 ', -- used by git log
    staged = '●', -- staged changes. always overrides the type icons
    added = '',
    deleted = '',
    ignored = ' ',
    modified = '○',
    renamed = '',
    unmerged = ' ',
    untracked = '?',
  },
  diagnostics = {
    Error = ' ',
    Warn = ' ',
    Hint = ' ',
    Info = ' ',
  },
  lsp = {
    unavailable = '',
    enabled = ' ',
    disabled = ' ',
    attached = '󰖩 ',
  },
  kinds = {
    Array = ' ',
    Boolean = '󰨙 ',
    Class = ' ',
    Color = ' ',
    Control = ' ',
    Collapsed = ' ',
    Constant = '󰏿 ',
    Constructor = ' ',
    Copilot = ' ',
    Enum = ' ',
    EnumMember = ' ',
    Event = ' ',
    Field = ' ',
    File = ' ',
    Folder = ' ',
    Function = '󰊕 ',
    Interface = ' ',
    Key = ' ',
    Keyword = ' ',
    Method = '󰊕 ',
    Module = ' ',
    Namespace = '󰦮 ',
    Null = ' ',
    Number = '󰎠 ',
    Object = ' ',
    Operator = ' ',
    Package = ' ',
    Property = ' ',
    Reference = ' ',
    Snippet = '󱄽 ',
    String = ' ',
    Struct = '󰆼 ',
    Text = ' ',
    TypeParameter = ' ',
    Unit = ' ',
    Unknown = ' ',
    Value = ' ',
    Variable = '󰀫 ',
  },
}
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

---@param key "directory"|"extension"|"file"|"filetype"|"os"
---@param lookup string?
---@return string icon, string? hl always return a string, hl group on success
local function get_mini_icon(_, key, lookup)
  if not _G.MiniIcons then
    return '󰟢', nil
  end
  if not lookup then
    lookup = key == 'filetype' and vim.bo.filetype or vim.api.nvim_buf_get_name(0)
  end
  local icon, hl = _G.MiniIcons.get(key, lookup)
  return icon .. ' ', hl
end

for _, key in ipairs(mini_icon_keys) do
  local function _get_mini_icon(_, lookup) return get_mini_icon(_, key, lookup) end

  M[key] = setmetatable({}, {
    __index = _get_mini_icon,
    __call = _get_mini_icon,
  })
end

return M
