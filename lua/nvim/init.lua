
--- @type snacks.Config
local opts = {
  bigfile = { enabled = true },
  dashboard = require('nvim.snacks.dashboard'),
  explorer = { replace_netrw = false }, -- using `oil` instead
  indent = { indent = { only_current = true, only_scope = true } },
  input = { enabled = true },
  notifier = { enabled = false },
  -- notifier = require('nvim.snacks.notifier'),
  quickfile = { enabled = true },
  scratch = { template = 'local x = \n\nprint(x)' },
  terminal = { enabled = true },
  scope = { enabled = true },
  scroll = { enabled = true },
  statuscolumn = { enabled = false },
  picker = require('nvim.snacks.picker'),
  styles = require('nvim.snacks.styles'),
  words = { enabled = true },
}

require('snacks').setup(opts)

_G.dd = function(...)
  Snacks.debug.inspect(...)
end
_G.bt = function(...)
  Snacks.debug.backtrace(...)
end
_G.p = function(...)
  Snacks.debug.profile(...)
end
--- @diagnostic disable-next-line: duplicate-set-field
vim._print = function(_, ...)
  dd(...)
end

_G.nv = require('nvim.util')
nv.config = require('nvim.config')

local thisdir = nv.stdpath.config .. '/lua/nvim/'
local mods = {}

-- top-level .lua files
for _, f in ipairs(vim.fn.globpath(thisdir, '*', false, true)) do
  if not f:match('init%.lua$') then
    print(f)
  end
end

-- one level of subdirs
for _, d in ipairs(vim.fn.globpath(dir, '*/', false, true)) do
  local subname = d:match('([^/]+)/$')
  if subname then
    local submods = {}
    for _, f in ipairs(vim.fn.globpath(d, '*.lua', false, true)) do
      local child = f:match('([^/]+)%.lua$')
      if child and child ~= 'init' then
        submods[child] = true
      end
    end
    if next(submods) then
      mods[subname] = submods
    else
      mods[subname] = true
    end
  end
end

-- _G.nv = vim._defer_require('nvim', mods)

nv.plugins = require('nvim.plugins')

local Plug = nv.plugins.Plug
local plugins = {}
local dir = nv.stdpath.config .. '/lua/nvim/plugins'
local files = vim.fn.globpath(dir, '*.lua', false, true)

for _, path in ipairs(files) do
  local name = path:match('([^/]+)%.lua$')
  local ok, mod = pcall(require, 'nvim.plugins.' .. name)
  if ok and mod then
    for _, spec in ipairs(vim.islist(mod) and mod or { mod }) do
      table.insert(plugins, Plug(spec))
      -- Plug(spec)
    end
  end
end

-- TODO: load func
vim.pack.add(nv.plugins._specs)

for _, plugin in ipairs(plugins) do
  plugin:init() -- calls setup
end

vim.schedule(function()
  require('which-key').add(nv.plugins._keys)
  for name, fn in pairs(nv.plugins._after) do
    nv.did.after[name] = pcall(fn)
  end
  nv.lazyload(function()
    for name, cmd in pairs(nv.plugins._commands) do
      nv.did.commands[name] = pcall(cmd)
    end
  end, 'CmdLineEnter')
end)

return nv
