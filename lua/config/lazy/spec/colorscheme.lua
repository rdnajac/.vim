local M = {
  'folke/tokyonight.nvim',
  -- dev = true,
}

---@class tokyonight.Config
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
    -- colors.red = '#ff0000'
    -- colors.orange = '#ff007c'
    -- colors.yellow = '#ff007c'
  end,
  on_highlights = function(hl, colors)
    -- hl['Folded'] = { fg = colors.blue, bg = '#16161d' }
    hl['Folded'] = { fg = colors.blue }
    -- hl['Special'] = { fg = 'NONE', bold = true }
    hl['SpecialWindow'] = { bg = '#1f2335' }
    -- hl['EdgyNormal'] = { bg = '#1f2335' }

    -- hl['NormalFloat'] = { bg = '#1f2335' }
    hl['SpellBad'] = { bg = colors.red }
    hl['FloatBorder'] = { fg = colors.green }

    -- hl['SnacksIndent'] = { fg = colors.green }
    -- hl['SnacksScope'] = { fg = colors.green }

    hl['CopilotSuggestion'] = { bg = '#414868', fg = '#7aa2f7' }
    hl['RenderMarkdownCode'] = { bg = 'NONE' }
  end,
}

return M
