  -- stylua: ignore
local c = {
  { fg =     '#C0CAF5' },
  { info =   '#0DB9D7' },
  { blue =   '#14AFFF' },
  { cyan =   '#1ABC9C' },
  { green =  '#39ff14' },
  { orange = '#FF9E64' },
  { purple = '#9D7CD8' },
  { red =    '#F7768E' },
  { yellow = '#E0AF68' },
}

Snacks.util.set_hl({
  Azure = { fg = c.info },
  Blue = { fg = c.blue },
  Cyan = { fg = c.teal },
  Green = { fg = c.green },
  Grey = { fg = c.fg },
  Orange = { fg = c.orange },
  Purple = { fg = c.purple },
  Red = { fg = c.red },
  Yellow = { fg = c.yellow },
}, { 'MiniIcons' })

local copilot = ''
-- `$PACKDIR/mini.nvim/lua/mini/icons.lua:690`
local M = {
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
    health = { '󱃪', 'Red' },
    LazyVim = { '󰒲', 'Blue' },
    ghostty = { '󰊠', 'Green' },
    vimtex = { '', 'Yellow' },
    ['R.nvim'] = { '󰟔', 'Cyan' },
    ['sidekick.nvim'] = { '', 'Purple' },
    ['snacks.nvim'] = { '󱥰', 'Orange' },
  },
  extension = {
    fastq = { '󰚄', 'Purple' },
    ['fastq.gz'] = { '󰚄', 'Red' },
  },
  file = {
    ['.keep'] = { '󰊢 ', 'Grey' },
    ['devcontainer.json'] = { '', 'Azure' },
    ['health.lua'] = { '', 'Red' },
  },
  filetype = {
    fish = { '', 'Cyan' },
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

M.mini_patterns = {
  directory = {
    ['vim%-.*'] = { '', 'Green' },
    ['lazy.*%.nvim'] = { '󰒲', 'Blue' },
    ['%.chezmoi.*'] = { '', 'Red' },
    ['mini%..*'] = { '󰚝', 'Red' },
  },
  file = {
    ['%.chezmoi.*[^.]'] = { '', 'Yellow' },
    ['fish_.*'] = { '󰈺', 'Yellow' },
  },
}

M.mini_override = function()
  local original_get = _G.MiniIcons.get
  ---@diagnostic disable-next-line: duplicate-set-field
  MiniIcons.get = function(category, name)
    local hl
    if vim.endswith(name, '.tmpl') then
      name = name:gsub('%.tmpl$', '')
      hl = 'MiniIconsGrey'
    end
    local basename = vim.fs.basename(name:gsub('dot_', '.'))
    for pattern, spec in pairs(M.mini_patterns[category] or {}) do
      -- add anchors to pattern for exact match
      if basename:match('^' .. pattern .. '$') then
        return spec[1], hl or ('MiniIcons' .. spec[2])
      end
    end
    local icon, orig_hl, is_default = original_get(category, name:gsub('dot_', '.'))
    return icon, hl or orig_hl, is_default
  end
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
