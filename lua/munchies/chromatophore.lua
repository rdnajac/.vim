local get_mode = require('util.mode').get

local colors = {
  green = '#39ff14',
  palegreen = '#9ece6a',
}

---@type table<string, string>
local ModeColor = {
  normal = colors.green,
  insert = '#14aeff',
  visual = '#f7768e',
  replace = '#ff007c',
  command = colors.palegreen,
  terminal = '#BB9AF7',
  pending = colors.palegreen,
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

local function chromatophore_refresh()
  local mode_color = current_mode_color()
  local black = '#000000'
  local grey = '#3b4261'
  -- local lightblue = '#7aa2f7'
  local lightblue = '#16161d'

  Snacks.util.set_hl({
    Chromatophore = { fg = mode_color, bg = 'NONE' },
    SnacksDashboardHeader = { link = 'Chromatophore' },
    String = { link = 'Chromatophore' },
    Folded = { link = 'Chromatophore' },
    Chromatophore_a = { fg = black, bg = mode_color, bold = true },
    Chromatophore_ab = { fg = mode_color, bg = grey },
    Chromatophore_b = { fg = mode_color, bg = grey, bold = true },
    Chromatophore_bc = { fg = grey, bg = lightblue },
    Chromatophore_c = { fg = mode_color, bg = lightblue },
    Chromatophore_y = { fg = mode_color, bg = '#000000', bold = true },
    Chromatophore_z = { fg = mode_color, bg = 'NONE', bold = true },
    StatusLine = { link = 'Chromatophore_a' },
    StatusLineNC = { link = 'Chromatophore_b' },
  })

  -- HACK: refresh tmux
  vim.fn.jobstart({ 'tmux', 'refresh-client', '-S' }, { detach = true })
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

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'msg',
  callback = function()
    Snacks.util.winhl('Chromatophore:Normal')
  end,
})
