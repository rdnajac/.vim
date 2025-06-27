---@class tokyonight.Config
return {
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
    -- colors.magenta = '#ff007c' -- function
    -- constant  #ff9e64a "orange
  end,
  on_highlights = function(hl, colors)
    hl['String'] = { fg = '#BB9AF7' }
    hl['Statement'] = { fg = colors.red }
    -- hl['CmdLine'] = { bg = '#3b4261' }
    hl['StatusLine'] = { bg = 'NONE' }
    hl['StatusLineNC'] = { bg = 'NONE' }
    -- hl['Tabline']             = { bg   = 'NONE' }
    hl['TabLineFill'] = { bg = 'NONE' }
    -- hl['TabLineSel']          = { bg   = 'NONE' }
    hl['Winbar'] = { bg = 'NONE' }
    -- hl['WinbarNC']            = { bg   = 'NONE' }
    hl['Folded'] = { fg = colors.blue }
    -- hl['Special']          = { fg   = 'NONE', bold    = true }

    hl['SpecialWindow'] = { bg = '#1f2335' }

    hl['MsgArea'] = { fg = colors.green }
    hl['SpellBad'] = { bg = colors.red }
    hl['FloatBorder'] = { fg = colors.green }

    hl['helpSectionDelim'] = { fg = colors.green }
    hl['CopilotSuggestion'] = { bg = '#414868', fg = '#7aa2f7' }
    hl['RenderMarkdownCode'] = { bg = 'NONE' }

    hl['SnacksPickerTitle'] = { bold = true, fg = colors.green }
    -- hl['@property'] = { fg = '#FFFFFF' }
    -- hl['@variable'] = { fg = '#E0AF68' }
    -- hl['@keyword'] = { fg = colors.red }
    -- hl['@variable'] = { fg = '#E0AF68' }
  end,
}
