local M = { 'folke/tokyonight.nvim' }

---@type tokyonight.Config
M.opts = {
  style = 'night',
  dim_inactive = true,
  transparent = true,
  styles = {
    comments = { italic = true },
    keywords = { italic = false, bold = true },
    sidebars = 'transparent',
    floats = 'transparent',
  },
  on_colors = function(colors)
    colors.blue = '#14afff'
    colors.green = '#39ff14'
    colors.red = '#f7768e'
  end,
  on_highlights = function(hl, colors)
    hl['Statement'] = { fg = colors.red }
    hl['Folded'] = { fg = colors.blue }
    hl['Special'] = { fg = colors.red, bold = true }
    hl['MsgArea'] = { fg = colors.green }
    hl['SpellBad'] = { bg = colors.red }
    hl['FloatBorder'] = { fg = colors.green }
    hl['SpecialWindow'] = { bg = '#1f2335' }
    hl['Cmdline'] = { bg = '#000000' }
    hl['WinSeparator'] = { fg = colors.green }
    -- TODO: move to vimline?
    -- hl['StatusLineNC'] = { bg = 'NONE' }
    -- hl['TabLineFill'] = { bg = 'NONE' }
    -- hl['Winbar'] = { bg = 'NONE' }
    -- TODO: move to snacks util color
    hl['helpSectionDelim'] = { fg = colors.green }
    hl['CopilotSuggestion'] = { bg = '#414868', fg = '#7aa2f7' }
    hl['SnacksPickerTitle'] = { bold = true, fg = colors.green }
  end,
}

M.config = function()
  require('tokyonight').load(M.opts)
end

return M
