vim.g.transparent = true

local M = {
  'folke/tokyonight.nvim',
  opts = require('nvim.tokyonight.opts'),
}

M.opts.plugins = require('nvim.tokyonight.plugins')

--- Calls `require('tokyonight').setup`, merging passed opts with the defaults
--- and storing the result on `require('tokyonight.config').options`
M.set_options = function() require('tokyonight').setup(M.opts) end

--- `require('tokyonight').setup` actually points to this function
M.config_setup = function() require('tokyonight.config').setup(M.opts) end

--- The actual setup function (called by `require.('tokyonight').load`)
--- opts are merged with defaults, but not stored
---
---@return ColorScheme, tokyonight.Highlights, tokyonight.Config
M.theme_setup = function() return require('tokyonight.theme').setup(M.opts) end

--- Generate a list of `vim.api.nvim_set_hl` calls for all groups
---@param groups tokyonight.Highlights
function M.colorscheme(groups)
  return vim
    .iter(groups)
    :map(function(group, hl)
      hl = type(hl) == 'string' and { link = hl } or hl
      vim.api.nvim_set_hl(0, group, hl)
      return ('vim.api.nvim_set_hl(0, %q, %s)'):format(
        group,
        vim.inspect(hl, { newline = '', indent = '' })
      )
    end)
    :totable()
end

---@param colors ColorScheme
function M.terminal(colors)
  for i, name in ipairs({ 'black', 'red', 'green', 'yellow', 'blue', 'magenta', 'cyan', 'white' }) do
    vim.g['terminal_color_' .. (i - 1)] = colors.terminal[name]
    vim.g['terminal_color_' .. (i + 7)] = colors.terminal[name .. '_bright']
  end
end

-- call this instead of any other setup funcs
--- Call setup and store results on this module
--- and manually tigger `ColorScheme` autocmd
M.init = function()
  M.opts = require('tokyonight.config').extend(M.opts) -- TODO: setup?
  M.colors = require('tokyonight.colors').setup(M.opts)
  M.groups = require('tokyonight.groups').setup(M.colors, M.opts)
  M.terminal(M.colors)
  M.colorscheme(M.groups)
  -- vim.cmd.doautocmd({ '<nomodeline>', 'ColorScheme' })
end

return M
