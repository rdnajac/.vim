local M = { 'folke/tokyonight.nvim' }

-- M.build = './scripts/build'

---@type tokyonight.Config
M.opts = {
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

M.patch = function()
  local tokyonight_path = vim.g.PACKDIR .. 'tokyonight.nvim/'
  package.preload['tokyonight.extra'] = function()
    local M = dofile(tokyonight_path .. '/lua/tokyonight/extra.lua')

    local orig_setup = M.setup

    M.setup = function(...)
      -- Patch the local `tokyonight` used inside the setup function
      for i = 1, math.huge do
        local name, val = debug.getupvalue(orig_setup, i)
        if not name then
          break
        end
        dd(name, val)
        if name == 'tokyonight' then
          local mod = vim.tbl_deep_extend('force', {}, val)
          local original_load = mod.load
          mod.load = function(opts)
            -- You can modify `opts` here
            opts.plugins.all = false
            -- or return your own colors, groups, opts
            return original_load(opts)
          end
          debug.setupvalue(orig_setup, i, mod)
          break
        end
      end

      return orig_setup(...)
    end

    return M
  end
end

return M
