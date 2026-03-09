local enabled = ' '
local disabled = ' '
local unavailable = ''
local copilot = ''

local M = {
  git = {
    commit = '󰜘 ',
    staged = '●',
    added = '',
    deleted = '',
    ignored = ' ',
    modified = '○',
    renamed = '',
    unmerged = ' ',
    untracked = '?',
  },
  diagnostics = {
    Error = '',
    Warn = '',
    Info = '',
    Hint = '',
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
    Copilot = copilot,
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
  lsp = {
    attached = '󰖩 ',
    disabled = disabled,
    enabled = enabled,
    unavailable = unavailable,
  },
}


M.blink = {
  buffer = '',
  cmdline = '',
  copilot = copilot,
  env = '',
  lazydev = '󰒲',
  lsp = '',
  omni = '',
  path = '',
  snippets = '',
}

-- TODO: add support for highlight groups
M.copilot = {
  Error = { ' ', 'DiagnosticError' },
  Inactive = { ' ', 'MsgArea' },
  Warning = { ' ', 'DiagnosticWarn' },
  Normal = { copilot, 'DiagnosticHint' },
}

M.diff = { add = '▎', change = '▎', delete = '' }

M.mason = {
  emojis = { package_installed = '✅', package_pending = '➡️', package_uninstalled = '❌' },
  nerd = { package_installed = '✓', package_pending = '➜', package_uninstalled = '✗' },
  round = { package_installed = ' ', package_pending = ' ', package_uninstalled = ' ' },
}

-- component and section separators appear as they
-- would in lualine, where left/right refer to the
-- side of the statusline they appear on, not the
-- direction they point to (unlike the item separators)
M.sep = {
  component = {
    angle = { left = '', right = '' },
    rounded = { left = '', right = '' },
  },
  section = {
    angle = { left = '', right = '' },
    rounded = { left = '', right = '' },
  },
  item = { left = ' ', right = ' ' },
}

M.mini = {
  directory = {
    ghostty = { '󰊠', 'Green' },
    LazyVim = { '󰒲', 'Blue' },
    ['R.nvim'] = { '󰟔', 'Cyan' },
  },
  extension = {
    fastq = { '󰚄', 'Purple' },
    ['fastq.gz'] = { '󰚄', 'Red' },
    ['json.tmpl'] = { ' ', 'Grey' },
    ['sh.tmpl'] = { ' ', 'Grey' },
    ['toml.tmpl'] = { ' ', 'Grey' },
    ['zsh.tmpl'] = { ' ', 'Grey' },
  },
  file = {
    ['.chezmoiignore'] = { '', 'Grey' },
    ['.chezmoiremove'] = { '', 'Grey' },
    ['.chezmoiroot'] = { '', 'Grey' },
    ['.chezmoiversion'] = { '', 'Grey' },
    ['.keep'] = { '󰊢 ', 'Grey' },
    ['devcontainer.json'] = { '', 'Azure' },
    -- dot_Rprofile = { '󰟔 ', 'Blue' },
    -- dot_bash_aliases = { ' ', 'Blue' },
    -- dot_zprofile = { ' ', 'Green' },
    -- dot_zshenv = { ' ', 'Green' },
    -- dot_zshprofile = { ' ', 'Green' },
    -- dot_zshrc = { ' ', 'Green' },
  },
  filetype = {
    ghostty = { '👻', 'Green' },
    ['nvim-pack'] = { '', 'Green' },
    printf = { '', 'Orange' },
    regex = { '', 'Orange' },
    sidekick_terminal = { ' ', '' },
    snacks_dashboard = { '󰨇 ', '' },
    snacks_terminal = { '🍬', '' },
  },
}

-- from `LazyVim`: add an inverse lookup table for lsp kinds
-- for i, name in ipairs(vim.lsp.protocol.SymbolKind) do
--   M.kinds[i] = M.kinds[name]
-- end

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

for _, key in ipairs({
  'directory',
  'extension',
  'file',
  'filetype',
  'os',
}) do
  local function _get_mini_icon(_, lookup) return get_mini_icon(_, key, lookup) end

  M[key] = setmetatable({}, {
    __index = _get_mini_icon,
    __call = _get_mini_icon,
  })
end

return M
