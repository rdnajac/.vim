-- TODO: check this out

-- do not add trouble symbols if aerial is enabled
-- And allow it to be overriden for some buffer types (see autocmds)

-- if vim.g.trouble_lualine and LazyVim.has('trouble.nvim') then
local trouble = require('trouble')
local symbols = trouble.statusline({
  mode = 'symbols',
  groups = {},
  title = false,
  filter = { range = true },
  format = '{kind_icon}{symbol.name:Normal}',
  hl_group = 'lualine_c_normal',
})
table.insert(opts.sections.lualine_c, {
  symbols and symbols.get,
  cond = function()
    return vim.b.trouble_lualine ~= false and symbols.has()
  end,
})
-- end
