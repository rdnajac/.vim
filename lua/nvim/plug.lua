-- use nvim's native package manager to clone plugins and load them
---Manages plugins only in a dedicated [vim.pack-directory]() (see |packages|):
---`$XDG_DATA_HOME/nvim/site/pack/core/opt`.
-- vim.g.PACKDIR = vim.fn.stdpath('data') .. '/site/pack/core/opt/'
-- /Users/rdn/.local/neovim/share/nvim/runtime/lua/vim/pack.lua:198
-- `return vim.fs.joinpath(vim.fn.stdpath('data'), 'site', 'pack', 'core', 'opt')`
vim.g.PACKDIR = vim.fn.expand('~/.local/share/nvim/site/pack/core/opt/')

---- Extend the
---@class PlugSpec : vim.pack.Spec
---@field build? string|fun(): nil
---@field config? fun(): nil
---@field dependencies? (string|PlugSpec)[]
---@field event? vim.api.keyset.events|vim.api.keyset.events[]
---@field enabled? boolean|fun():boolean
---@field priority? number

local M = {}

---@param v string|vim.pack.Spec|PlugSpec
---@return vim.pack.Spec|nil
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

  local name = nil
  if type(v) == 'table' then
    name = v.name or (src:gsub('%.git$', '')):match('[^/]+$')
  else
    name = (src:gsub('%.git$', '')):match('[^/]+$')
  end

  local version = type(v) == 'table' and v.version or nil

  return { src = src, name = name, version = version }
end

-- Require and register a plugin module by absolute path
-- returns the spec andhte module
---@param modname string
---@return vim.pack.Spec|nil, PlugSpec|nil
M.load = function(modname)
  local ok, mod = pcall(require, modname)
  if not ok then
    vim.notify('Failed to require "' .. modname .. '": ' .. mod, vim.log.levels.ERROR)
    return nil, nil
  end
  if mod.enabled == false or (type(mod.enabled) == 'function' and not mod.enabled()) then
    return nil, nil
  end
  local spec = M.to_spec(mod)
  return spec, mod
end

local aug = vim.api.nvim_create_augroup('LazyLoad', { clear = true })

---@param config fun(): nil
M.lazyload = function(event, config)
  vim.api.nvim_create_autocmd(event, {
    group = aug,
    once = true,
    callback = config,
  })
end

M.build = require('nvim.build')

-- vim.api.nvim_create_user_command('Plug', function(args)
--   assert(type(args.fargs) == 'table', 'Plug command requires a table argument')
--   vim.pack.add(args.fargs)
-- end, { nargs = '*', force = true })

vim.api.nvim_create_user_command('PackUpdate', function(opts)
  -- pass nil to update all plugins
  vim.pack.update(nil, { force = opts.bang })
end, { bang = true })

return M
