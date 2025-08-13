-- TODO: rewrite in vimscript and avoid this dependency
if not package.loaded['snacks'] then
  vim.notify('Chromatophore requires Snacks to be loaded first.', vim.log.levels.WARN)
  return
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
local eigengrau = '#16161d'

local function chromatophore_refresh()
  local mode_color = vim.fn['vim#mode#color']()

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
    -- InclineNormal = { link = 'Chromatophore_a' },
    -- InclineNormalNC = { link = 'Chromatophore' },
  })
  -- TODO: check for tmux first
  -- vim.system({ 'tmux', 'refresh-client', '-S' }) -- HACK: force refresh tmux
end

chromatophore_refresh()

vim.api.nvim_create_autocmd({ 'ModeChanged', 'DirChanged', 'BufEnter' }, {
  group = vim.api.nvim_create_augroup('ChromatophoreRefresh', { clear = true }),
  callback = chromatophore_refresh,
})
