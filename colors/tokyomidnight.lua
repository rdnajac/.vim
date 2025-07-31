---@type tokyonight.Config
local opts = {
  style = 'night',
  transparent = true,
  styles = {
    comments = { italic = true },
    keywords = { italic = false, bold = true },
    -- variables = { italic = true },
    sidebars = 'transparent',
    floats = 'transparent',
  },
  dim_inactive = true,
  on_colors = function(colors)
    colors.blue = '#14afff'
    colors.green = '#39ff14'
    -- colors.red = '#f7768e'
  end,
  on_highlights = function(hl, colors)
    hl['Statement'] = { fg = colors.red }
    hl['Special'] = { fg = colors.red, bold = true }
    hl['SpellBad'] = { bg = colors.red }
    hl['SpecialWindow'] = { bg = '#1f2335' }
    -- TODO: move to vimline?
    -- hl['StatusLineNC'] = { bg = 'NONE' }
    -- hl['TabLineFill'] = { bg = 'NONE' }
    -- hl['Winbar'] = { bg = 'NONE' }
    hl['Cmdline'] = { bg = '#000000' }
  end,
  plugins = {
    all = false,
    -- ale = true,
    -- fzf = true,
    mini = true,
    copilot = true,
    render_markdown = true,
    snacks = true,
    -- treesitter = false,
    -- semantic_tokens = false,
    -- kinds = false,
  },
}

require('tokyonight').load(opts)
