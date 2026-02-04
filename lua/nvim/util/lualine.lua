-- `https://github.com/nvim-lualine/lualine.nvim/wiki/Component-snippets`
local M

M.sections = {}
M.inactive_sections = {}
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

-- local tabs = {
--   'tabs',
--   -- mode = 0,
--   use_mode_colors = true,
--   path = 0,
--   -- tabs_color = { active = nil, inactive = nil },
--   show_modified_status = true,
--   symbols = { modified = ',+' },
-- }

-- local termstatus = {
--   function()
--     if vim.bo.buftype == 'terminal' then
--       return "%{% &buftype == 'terminal' ? ' %{&channel}' : '' %}"
--     end
--     return "%{% &buflisted ? '%n' : '󱪟 ' %}" .. "%{% &bufhidden == '' ? '' : '󰘓 ' %}"
--   end,
-- }

-- local status_icons = {
--   nv.treesitter.status,
--   nv.lsp.status,
--   { require('nvim.plugins.r').status },
-- }

-- local diagnostic = function() return vim.diagnostic.status() end

-- M.opts.inactive_winbar = {
--   lualine_a = { [[%{%v:lua.nv.icons.filetype()%}]] },
--   lualine_b = { '%' },
--   lualine_c = { M.winbar.b },
-- }

return M
