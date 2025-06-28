local get_mode = require('nvim.mode').get_mode

---@type table<string, string>
local ModeColor = {
  normal = '#9ece6a',
  insert = '#14aeff',
  visual = '#f7768e',
  replace = '#ff007c',
  command = '#39ff14',
  terminal = '#BB9AF7',
  pending = '#39ff14',
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
  local black = "#000000"
  local grey = "#3b4261"

  Snacks.util.set_hl({
    Chromatophore = { fg = mode_color, bg = "NONE" },
    String = { link = "Chromatophore" },

    Chromatophore_a  = { fg = black, bg = mode_color, bold = true },
    Chromatophore_ab = { fg = mode_color, bg = grey },
    Chromatophore_b  = { fg = mode_color, bg = grey, bold = true },
    Chromatophore_c  = { fg = mode_color, bg = "NONE" },
    Chromatophore_z  = { fg = mode_color, bg = "NONE", bold = true },
  })

  Snacks.util.winhl({ String = "String" })
end

vim.api.nvim_create_autocmd("ModeChanged", {
  group = vim.api.nvim_create_augroup("Chromatophore", { clear = true }),
  callback = chromatophore_refresh,
})

chromatophore_refresh()
