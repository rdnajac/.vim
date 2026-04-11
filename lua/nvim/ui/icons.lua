local copilot = ''
-- `$PACKDIR/mini.nvim/lua/mini/icons.lua:682`
local M = {
  pickers = {
    buffers = '',
    explorer = '󰙅',
    files = '',
    grep = '󰱽',
  },
  buffer = '',
  cmdline = '',
  lsp = '',
  omni = '',
  path = '',
  snippets = '',
  dadbod = '',
  env = '',
  lazydev = '󰒲',
  copilot = copilot,
  diff = { add = '▎', change = '▎', delete = '' },
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
  -- copilot_status = {
  --   Error = { '', 'DiagnosticError' },
  --   Inactive = { '', 'MsgArea' },
  --   Warning = { '', 'DiagnosticWarn' },
  -- },
  lsp_status = {
    active = '󰖩',
    busy = '󱛇',
    stopped = '󰖪',
  },
}

local severity = vim.diagnostic.severity
-- TODO: use table invert fn
M.diagnostics = {
  [severity.ERROR] = '',
  [severity.WARN] = '',
  [severity.INFO] = '',
  [severity.HINT] = '',
  Error = '',
  Warn = '',
  Info = '',
  Hint = '',
}

local hl_map = {
  [vim.diagnostic.severity.ERROR] = 'DiagnosticSignError',
  [vim.diagnostic.severity.WARN] = 'DiagnosticSignWarn',
  [vim.diagnostic.severity.INFO] = 'DiagnosticSignInfo',
  [vim.diagnostic.severity.HINT] = 'DiagnosticSignHint',
}

-- TODO:
-- ---@enum status
-- local status = {
--   ACTIVE = 1,
--   BUSY = 2,
--   INACTIVE = 3,
-- }
--
-- ---@enum statusName
-- local severity_invert = {
--   [1] = 'ERROR',
--   [2] = 'WARN',
--   [3] = 'INFO',
-- }

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
  },
  file = {
    ['.keep'] = { '󰊢 ', 'Grey' },
    ['devcontainer.json'] = { '', 'Azure' },
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
  lsp = {
    -- array = ' ',
    -- boolean = '󰨙 ',
    -- class = ' ',
    -- color = ' ',
    control = ' ',
    collapsed = ' ',
    constant = '󰏿 ',
    -- constructor = ' ',
    copilot = copilot,
    enum = ' ',
    enummember = ' ',
    -- event = ' ',
    field = ' ',
    -- file = ' ',
    -- folder = ' ',
    ['function'] = '󰊕 ',
    interface = ' ',
    -- key = ' ',
    keyword = ' ',
    method = '󰊕 ',
    module = ' ',
    -- namespace = '󰦮 ',
    null = ' ',
    number = '󰎠 ',
    object = ' ',
    operator = ' ',
    -- package = ' ',
    -- property = ' ',
    -- reference = ' ',
    snippet = '󱄽 ',
    string = ' ',
    struct = '󰆼 ',
    -- text = ' ',
    -- typeparameter = ' ',
    -- unit = ' ',
    unknown = ' ',
    value = ' ',
    variable = '󰀫 ',
  },
}

local function minify(v)
  local glyph = type(v) == 'table' and v[1] or v
  local color = type(v) == 'table' and v[2] or 'Green'
  return { glyph = glyph, hl = 'MiniIcons' .. color }
end

local opts = vim.iter(M.mini):fold({
  use_file_extension = function(ext, _) return ext:sub(-3) ~= 'scm' end,
}, function(acc, k, v) return rawset(acc, k, vim.tbl_map(minify, v)) end)

require('mini.icons').setup(opts)

-- HACK: Override to use wildcard matching for directories
local override = {
  directory = {
    ['vim%-.*'] = { '', 'Green' },
    ['lazy.*%.nvim'] = { '󰒲', 'Blue' },
    ['%.chezmoi.*'] = { '', 'Red' },
  },
  file = {
    ['%.chezmoi.*[^.]'] = { '', 'Yellow' },
  },
}

local original_get = _G.MiniIcons.get

-- TODO: if vim.endswith(name, '.tmpl') then only change the color
---@diagnostic disable-next-line: duplicate-set-field
MiniIcons.get = function(category, name)
  name = name:gsub('dot_', '.'):gsub('%.tmpl$', '')
  local patterns = override[category]
  if patterns then
    local entry = vim.fs.basename(name)
    for pattern, rv in pairs(override[category]) do
      -- add anchors to pattern for exact match
      if entry:match('^' .. pattern .. '$') then
        return rv[1], 'MiniIcons' .. rv[2]
      end
    end
  else
  end
  return original_get(category, name)
end

---@param key "directory"|"extension"|"file"|"filetype"|"os"
---@param lookup string?
---@return string icon, string? hl always return a string, hl group on success
local function _get_icon(_, key, lookup)
  lookup = lookup or (key == 'filetype' and vim.bo.filetype or vim.api.nvim_buf_get_name(0))
  return _G.MiniIcons.get(key, lookup)
end

for _, key in ipairs({ 'directory', 'extension', 'file', 'filetype', 'os' }) do
  local function get_icon(_, lookup) return _get_icon(_, key, lookup) end
  M[key] = setmetatable({}, { __index = get_icon, __call = get_icon })
end

return M
