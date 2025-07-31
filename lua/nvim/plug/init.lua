-- use nvim's native package manager to clone plugins and load them
---Manages plugins only in a dedicated [vim.pack-directory]() (see |packages|):
---`$XDG_DATA_HOME/nvim/site/pack/core/opt`.
-- vim.g.PACKDIR = vim.fn.stdpath('data') .. '/site/pack/core/opt/'
-- /Users/rdn/.local/neovim/share/nvim/runtime/lua/vim/pack.lua:198
-- `return vim.fs.joinpath(vim.fn.stdpath('data'), 'site', 'pack', 'core', 'opt')`
vim.g.PACKDIR = vim.fn.expand('~/.local/share/nvim/site/pack/core/opt/')

---@class PluginSpec : vim.pack.Spec
---@field build? string|fun(): nil
---@field config? fun(): nil
---@field dependencies? (string|PluginSpec)[]
---@field event? vim.api.keyset.events|vim.api.keyset.events[]
---@field enabled? boolean|fun():boolean

local M = {}

-- ~/.local/neovim/share/nvim/runtime/lua/vim/pack.lua
---@param v string|vim.pack.Spec|PluginSpec
---@return string|vim.pack.Spec|nil
M.to_spec = function(v)
  local function is_user_repo(src)
    return src:match('^%S+/%S+$') and not src:match('^https?://') and not src:match('^~/')
  end

  local src = type(v) == 'string' and v or v[1] or v.src
  if not src or src == '' or type(src) ~= 'string' then
    return nil
  end

  if is_user_repo(src) then
    src = 'https://github.com/' .. src
  end

  if type(v) == 'string' or (not v.name and not v.version) then
    return src
  end

  return { src = src, name = v.name, version = v.version }
end

local aug = vim.api.nvim_create_augroup('LazyLoad', { clear = true })

M.config = function(plugin)
  if plugin.event then
    vim.api.nvim_create_autocmd(plugin.event, {
      group = aug,
      once = true,
      callback = plugin.config,
    })
  else
    plugin.config()
  end
end

require('nvim.plug.build') -- automacic plugin building
require('nvim.plug.commands') -- user commands

return M
