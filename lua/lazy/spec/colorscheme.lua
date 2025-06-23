return {
  'folke/tokyonight.nvim',
  -- dev = true,
  ---@class tokyonight.Config
  opts = {
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
    -- stylua: ignore
    on_highlights = function(hl, colors)
      hl['StatusLine']          = { bg   = 'NONE' }
      hl['StatusLineNC']        = { bg   = 'NONE' }
      -- hl['Tabline']             = { bg   = 'NONE' }
      -- hl['TabLineFill']         = { bg   = 'NONE' }
      -- hl['TabLineSel']          = { bg   = 'NONE' }
      -- hl['Winbar']              = { bg   = 'NONE' }
      -- hl['WinbarNC']            = { bg   = 'NONE' }
      hl['Folded']              = { fg   = colors.blue }
      -- hl['Special']          = { fg   = 'NONE', bold    = true }

      hl['SpecialWindow']       = { bg   = '#1f2335' }

      hl['MsgArea']             = { fg   = colors.green }
      hl['SpellBad']            = { bg   = colors.red }
      hl['FloatBorder']         = { fg   = colors.green }

      hl['helpSectionDelim']    = { fg   = colors.green }
      hl['CopilotSuggestion']   = { bg   = '#414868', fg   = '#7aa2f7' }
      hl['RenderMarkdownCode']  = { bg   = 'NONE' }

      hl['SnacksPickerTitle']   = { bold = true, fg        = colors.green }


    end,
  },
}
