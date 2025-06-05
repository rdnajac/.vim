return {
  {
    'folke/tokyonight.nvim',
    priority = 1001,
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
      on_highlights = function(hl, _)
        hl['Folded'] = { fg = '#7aa2f7', bg = '#16161d' }
        hl['String'] = { fg = '#39ff14' }
        hl['SpecialWindow'] = { bg = '#1f2335' }
        -- hl['NormalFloat'] = { bg = '#1f2335' }
        hl['SpellBad'] = { bg = '#ff0000' }
        hl['CopilotSuggestion'] = { bg = '#414868', fg = '#7AA2F7' }
      end,
    },
  },
}
