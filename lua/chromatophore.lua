if not package.loaded['snacks'] then
  vim.notify('Chromatophore requires Snacks to be loaded first.', vim.log.levels.WARN)
  return
end

local get_mode = require('util.mode').get

local colors = {
  green = '#39ff14',
  palegreen = '#9ece6a',
  blue = '#14aeff',
}

---@type table<string, string>
local ModeColor = {
  normal = colors.palegreen,
  insert = colors.green,
  visual = '#f7768e',
  replace = '#ff007c',
  command = colors.blue,
  terminal = '#BB9AF7',
  pending = colors.blue,
}

---@type table<string, string>
-- stylua: ignore
local ModeLowerKey = setmetatable({
  NORMAL        = 'normal',
  INSERT        = 'insert',
  VISUAL        = 'visual',
  ['V-LINE']    = 'visual',
  ['V-BLOCK']   = 'visual',
  SELECT        = 'visual',
  ['S-LINE']    = 'visual',
  ['S-BLOCK']   = 'visual',
  REPLACE       = 'replace',
  ['V-REPLACE'] = 'replace',
  COMMAND       = 'command',
  EX            = 'command',
  CONFIRM       = 'command',
  SHELL         = 'shell',
  TERMINAL      = 'terminal',
  O_PENDING     = 'pending',
  MORE          = 'more',
}, {
  __index = function()
    return 'normal'
  end,
})

local function current_mode_color()
  return ModeColor[ModeLowerKey[get_mode()]]
end

-- list of groups that should be linked to Chromatophore
local linked_groups = {
  'FloatBorder',
  'FloatTitle',
  'Folded',
  'MsgArea',
  'SnacksDashboardHeader',
  'String',
  'WinSeparator',
  'helpSectionDelim',
}

for _, group in ipairs(linked_groups) do
  Snacks.util.set_hl({ [group] = { link = 'Chromatophore' } })
end

local black = '#000000'
local grey = '#3b4261'
local lightblue = '#7aa2f7'
local eigengrau = '#16161d'

local function chromatophore_refresh()
  local mode_color = current_mode_color()

  -- stylua: ignore
  Snacks.util.set_hl({
    Black = { fg = black },
    Chromatophore =    { fg = mode_color, bg = 'NONE' },
    Chromatophore_a =  { fg = black,      bg = mode_color, bold = true },
    Chromatophore_ab = { fg = mode_color, bg = grey },
    Chromatophore_b =  { fg = mode_color, bg = grey,       bold = true },
    Chromatophore_bc = { fg = grey,       bg = eigengrau },
    Chromatophore_c =  { fg = mode_color, bg = eigengrau  },
    Chromatophore_y =  { fg = mode_color, bg = black,      bold = true },
    Chromatophore_z =  { fg = mode_color, bg = eigengrau,  bold = true },
    -- StatusLine = { link = 'Chromatophore_a' },
    -- StatusLineNC = { link = 'Chromatophore_b' },
  })

  vim.system({ 'tmux', 'refresh-client', '-S' }) -- HACK: force refresh tmux
end

chromatophore_refresh()

-- TODO: move to tmux section
local events = { 'ModeChanged', 'DirChanged', 'BufEnter' }

local group = vim.api.nvim_create_augroup('Chromatophore', { clear = true })

for _, event in ipairs(events) do
  vim.api.nvim_create_autocmd(event, {
    group = group,
    callback = chromatophore_refresh,
  })
end
