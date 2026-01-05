-- `https://github.com/nvim-lualine/lualine.nvim/wiki/Component-snippets`
local M = {
  'nvim-lualine/lualine.nvim',
  opts = {
    options = {
      component_separators = { left = '', right = '' },
      -- section_separators = nv.icons.sep.section.rounded,
      section_separators = { left = '', right = '' },
      disabled_filetypes = {
        statusline = { pattern = 'snacks_dashboard' },
        winbar = { 'netrw', 'snacks_dashboard', 'snacks_picker_list', 'snacks_picker_input' },
        tabline = { 'snacks_dashboard' },
      },
      ignore_focus = {
        -- 'man',
        -- 'help',
      },
      -- theme = {
      --   normal = { a = 'Chromatophore_a', b = 'Chromatophore_b', c = 'Chromatophore_c' },
      -- },
      -- use_mode_colors = false,
    },
    extensions = { 'man' },
  },
}

-- M.opts.sections = {
--   lualine_a = {
--     {
--       function()
--         return nv.path.relative_parts()[1]
--       end,
--     },
--   },
--   lualine_b = { nv.path.relative_parts()[2] },
--   lualine_c = {},
--   lualine_x = {},
--   lualine_y = {},
--   -- lualine_z = { Snacks and Snacks.profiler.status() or nil },
-- }

M.opts.inactive_sections = {}

M.opts.tabline = {
  lualine_a = {
    {
      function()
        return vim.fn.fnamemodify(Snacks.git.get_root() or '', ':p:~')
      end,
    },
  },
  lualine_b = {
    {
      'tabs',
      -- mode = 0,
      use_mode_colors = true,
      path = 0,
      -- tabs_color = { active = nil, inactive = nil },
      show_modified_status = true,
      symbols = { modified = ',+' },
    },
  },
  lualine_c = {
    -- { 'diff', separator = '' },
    -- { 'diagnostics', separator = '' },
  },
}

M.opts.winbar = {
  lualine_a = { require('nvim.util.status').buffer },
  lualine_b = {
    {
      function()
        if vim.bo.buftype == 'terminal' then
          return "%{% &buftype == 'terminal' ? ' %{&channel}' : '' %}"
        end
        return "%{% &buflisted ? '%n' : '󱪟 ' %}" .. "%{% &bufhidden == '' ? '' : '󰘓 ' %}"
      end,
    },
    -- nv.treesitter.status,
    -- nv.lsp.status,
    -- nv.blink.status,
    -- { require('nvim.plugins.r').status },
  },
  lualine_c = {
    -- {
    --   function()
    --     return vim.diagnostic.status()
    --   end,
    -- },
  },
}

M.opts.inactive_winbar = {
  lualine_a = { [[%{%v:lua.nv.icons.filetype()%}]] },
  lualine_b = { '%t' },
  -- lualine_c = { M.winbar.b },
}

return M
-- vim: fdl=2
