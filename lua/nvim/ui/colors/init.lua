local M = { 'folke/tokyonight.nvim' }

M.colors = require('nvim.ui.colors._colors')

M.terminal = function(colors)
  local term_colors = colors or M.colors.terminal
  for i, color in ipairs({ 'black', 'red', 'green', 'yellow', 'blue', 'magenta', 'cyan', 'white' }) do
    vim.g['terminal_color_' .. (i - 1)] = term_colors[color]
    vim.g['terminal_color_' .. (i + 7)] = term_colors[color .. '_bright']
    -- vim.cmd(([[let g:terminal_color_%d = '%s']]):format(i - 1, term_colors[color]))
    -- vim.cmd(([[let g:terminal_color_%d = '%s']]):format(i + 7, term_colors[color .. '_bright']))
  end
end

local groups = require('nvim.ui.colors.groups')
M.tokyonight = vim.iter(groups):fold({}, function(acc, _, v)
  return vim.tbl_extend('force', acc, v)
end)

nv.cache(M.tokyonight, 'tokyonight.json')

M.scheme = function(groups)
  vim.iter(groups or M.tokyonight):each(function(name, hl)
    vim.api.nvim_set_hl(0, name, type(hl) == 'string' and { link = hl } or hl)
  end)
end

---@return string[] list of `vim.api.nvim_set_hl` calls for all groups
function M.lua_api()
  return vim
    .iter(M.tokyonight)
    :map(function(name, hl)
      hl = type(hl) == 'string' and { link = hl } or hl
      return ('vim.api.nvim_set_hl(0, %q, %s)'):format(name, vim.inspect(hl, { newline = '', indent = '' }))
    end)
    :totable()
end

--- Simple string interpolation. Example template: "${name} is ${value}"
---
--- @param str string template string
--- @param table table key value pairs to replace in the string
local function template(str, table)
  return (
    str:gsub('($%b{})', function(w)
      return vim.tbl_get(table, unpack(vim.split(w:sub(3, -2), '.', { plain = true }))) or w
    end)
  )
end

M.extra = function(name)
  local lines = require('nvim.ui.colors.extra.' .. name).generate(M.colors)
  vim.fn.writefile(lines, vim.fn.stdpath('cache') .. '/tokyonight.' .. name)
end

-- Snacks.util.set_hl({
--   Azure = { fg = c.blue2 },
--   Blue = { fg = c.blue },
--   Cyan = { fg = c.teal },
--   Green = { fg = c.green },
--   Grey = { fg = c.fg },
--   Orange = { fg = c.orange },
--   Purple = { fg = c.purple },
--   Red = { fg = c.red },
--   Yellow = { fg = c.yellow },
-- }, { 'MiniIcons' })

return M
