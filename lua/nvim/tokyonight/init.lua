-- TODO: see `tokyonight/util`
local M = { 'folke/tokyonight.nvim' }
M.opts = require('nvim.tokyonight.opts')
M.opts.plugins = require('nvim.tokyonight.plugins')

--- Calls `require('tokyonight').setup`, merging passed opts with the defaults
--- and storing the result on `require('tokyonight.config').options`
-- M.set_options = function() require('tokyonight').setup(M.opts) end

--- `require('tokyonight').setup` actually points to this function
-- M.config_setup = function() require('tokyonight.config').setup(M.opts) end

--- Generate a list of `vim.api.nvim_set_hl` calls for all groups
--- same as `require('tokyonight.theme').setup`, the actual setup function
--- (called by `require.('tokyonight').load`)
--- opts are merged with defaults, but not stored
--- returns ColorScheme, tokyonight.Highlights, tokyonight.Config
---
---@param groups tokyonight.Highlights
---@return string[] list of `vim.api.nvim_set_hl` calls for all groups
function M.lua_api(groups)
  return vim
    .iter(groups)
    :map(function(name, hl)
      hl = type(hl) == 'string' and { link = hl } or hl
      return ('vim.api.nvim_set_hl(0, %q, %s)'):format(
        name,
        vim.inspect(hl, { newline = '', indent = '' })
      )
    end)
    :totable()
end

function M.colorscheme(groups)
  vim.iter(groups):each(function(name, hl)
    hl = type(hl) == 'string' and { link = hl } or hl
    vim.api.nvim_set_hl(0, name, hl)
  end)
  vim.cmd.doautocmd({ '<nomodeline>', 'ColorScheme' })
end

function M.vimscript(groups) return require('nvim.tokyonight.scheme').gen(groups) end

---@param colors ColorScheme
function M.terminal(colors)
  for i, color in ipairs({ 'black', 'red', 'green', 'yellow', 'blue', 'magenta', 'cyan', 'white' }) do
    vim.g['terminal_color_' .. (i - 1)] = colors.terminal[color]
    vim.g['terminal_color_' .. (i + 7)] = colors.terminal[color .. '_bright']
  end
end

return M
