vim.g.transparent = true

local M = { 'folke/tokyonight.nvim' }

local function dynamic_plugins()
  return vim
    .iter(require('tokyonight.groups').plugins)
    :fold({ all = false }, function(acc, name, plugin)
      if
        vim.uv.fs_stat(vim.env.PACKDIR .. '/' .. name)
        or (
          vim.startswith(name, 'mini')
          and vim.tbl_contains({
            -- 'animate', 'clue', 'completion', 'cursorword', 'deps',
            'diff',
            'files',
            'hipatterns',
            'icons',
            -- 'indentscope', 'jump', 'map', 'notify', 'operators' 'pick', 'starter',
            'surround',
            -- 'statusline', 'tabline', 'test', 'trailspace',
          }, name:sub(6))
        )
      then
        return rawset(acc, plugin, true)
      else
        return acc
      end
    end)
end

local opts = function()
  local opts = require('nvim.ui.tokyonight.opts')
  opts.plugins = dynamic_plugins()
  return opts
end

--- Calls `require('tokyonight').setup`, merging passed opts with the defaults
--- and storing the result on `require('tokyonight.config').options`
M.set_options = function() require('tokyonight').setup(opts()) end

--- `require('tokyonight').setup` actually points to this function
M.config_setup = function() require('tokyonight.config').setup(opts()) end

--- The actual setup function (called by `require.('tokyonight').load`)
--- opts are merged with defaults, but not stored
---@return ColorScheme, tokyonight.Highlights, tokyonight.Config
M.theme_setup = function() return require('tokyonight.theme').setup(opts()) end

--- Generate a list of `vim.api.nvim_set_hl` calls for all groups in `M.groups`
function M.colorscheme()
  return vim
    .iter(M.groups)
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
  for idx, name in ipairs({ 'black', 'red', 'green', 'yellow', 'blue', 'magenta', 'cyan', 'white' }) do
    vim.g['terminal_color_' .. (idx - 1)] = colors.terminal[name]
    vim.g['terminal_color_' .. (idx + 7)] = colors.terminal[name .. '_bright']
  end
end

-- call this instead of any other setup funcs
--- Call setup and store results on this module
--- and manually tigger `ColorScheme` autocmd
M.init = function()
  vim.schedule(function()
    M.opts = require('tokyonight.config').extend(opts()) -- TODO: setup?
    M.colors = require('tokyonight.colors').setup(M.opts)
    M.groups = require('tokyonight.groups').setup(M.colors, M.opts)
    M.terminal(M.colors)
    M.colorscheme()
  end)
  vim.cmd.doautocmd({ '<nomodeline>', 'ColorScheme' })
end

return M
