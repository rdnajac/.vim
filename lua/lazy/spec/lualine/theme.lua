-- originally generated from `require('lualine.themes.auto')`
-- with tokyonight.nvim as current colorscheme
local color = _G.modemap
-- local black = ''#16161e'
local black = '#000000'
local grey = '#3b4261'

M = {}

for mode, col in pairs(color) do
  M[mode] = {
    a = { bg = col, fg = black, gui = 'bold' },
    b = { bg = grey, fg = col, gui = 'bold' },
    c = { bg = 'NONE', fg = col },
    z = { bg = 'NONE', fg = col, gui = 'bold' },
  }
end

M.normal.x = { bg = color.normal, fg = 'NONE' }
M.normal.y = { bg = grey, fg = color.normal, gui = 'bold' }
M.normal.z = { fg = color.normal, bg = 'NONE', gui = 'bold' }

M.inactive = {
  a = { bg = 'NONE', fg = color.insert, gui = 'bold' },
  -- b = { bg = '#16161e', fg = grey, gui = 'bold' },
  -- c = { bg = 'NONE', fg = grey },
  z = { fg = color.insert, bg = 'NONE', gui = 'bold' },
}

-- Map Vim modes to your color keys
local mode_map = {
  n = 'normal',
  i = 'insert',
  v = 'visual',
  V = 'visual',
  [''] = 'visual',
  c = 'command',
  r = 'replace',
  R = 'replace',
  t = 'terminal',
}

local hl_strings = function()
  local mode = vim.fn.mode()
  local key = mode_map[mode] or 'normal'
  local fg = color[key] or color.normal

  Snacks.util.set_hl({
    String = { fg = fg },
  }, { default = false })

  Snacks.util.winhl({ String = 'String' })
end

local visual_modes = { 'v', 'V', '\22' }

-- ModeChanged for all modes except Visual
vim.api.nvim_create_autocmd('ModeChanged', {
  callback = function()
    if not vim.tbl_contains(visual_modes, vim.fn.mode()) then
      hl_strings()
    end
  end,
  desc = 'Sync String highlight color with current mode (excluding visual)',
})

-- Separate key-based handler for visual modes
local visual_refresh = function()
  Snacks.util.set_hl({ String = { fg = color.visual } })
  require('lualine').refresh()
end

for _, key in ipairs(visual_modes) do
  Snacks.util.on_key(key, visual_refresh)
end

return M
