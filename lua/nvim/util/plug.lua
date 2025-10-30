--- what junegunn/vim-plug returns as `g:plugs`
---@class vimPlugSpec
---@field uri string Git URL of the plugin repository.
---@field dir string Local directory where the plugin is installed.
---@field frozen integer Whether the plugin is frozen (0 or 1).
---@field branch string Branch name if specified.

---@alias PluginTable table<string, vimPlugSpec>
vim.g.plugs = vim.g.plugs or {}

local nv = _G.nv or require('nvim.util')

--- @class Plugin
--- @field [1] string The plugin name in `user/repo` format.
--- @field enabled boolean Defaults to `true`.
--- @field name string The plugin name as evauluated by `vim.pack`.
--- @field did_setup? boolean Tracks if `setup()` has been called.
--- @field after? fun():nil Commands to run after the plugin is loaded.
--- @field build? string|fun():nil Callback after plugin is installed/updated.
--- @field config? boolean|fun():nil Setup fun or, if true, mod.setup({})
--- @field event? string |string[] Autocommand event(s) to lazy-load on.
--- @field lazy? boolean Defaults to `false`. Load on `VimEnter` if `true`.
--- @field keys? table|fun():table Keymaps to bind for the plugin.
--- @field opts? table|fun():table Options to pass to the plugin's `setup()`.
--- @field data? any additional data to pass to `vim.pack.add()`
local Plugin = {}
Plugin.__index = Plugin

-- shared table of keys for all plugins
local keys = {}

function Plugin:register_keys()
  keys[self.name] = self.keys
end

function Plugin:schedule_after()
  if vim.is_callable(self.after) then
    vim.schedule(self.after)
  end
end

function Plugin.new(t)
  local self = setmetatable(t, Plugin)
  self.name = self[1]:match('[^/]+$') -- `repo` part of `user/repo`
  -- store things to be passed to `vim.pack.Spec.data`
  self.data = {
    -- build = self.build, -- TODO:
    setup = function()
      return self:setup()
    end,
  }
  -- TODO:
  -- if config is false, skip setup entirely
  -- a missing did_setup should skip setup entirely
  -- self.did_setup = self.config ~= false and false or nil
  self.did_setup = false

  -- if config is truem set missing opts to {}
  if not self.opts and self.config == true then
    self.opts = {} -- HACK: handles `config = true`
  end
  return self
end

--- Convert the `Plugin` to a `vim.pack.Spec` for use with `vim.pack`.
--- The `spec`'s `data` field will contain the `build` and `setup` functions.
--- @return vim.pack.Spec
function Plugin:tospec()
  if self.enabled == false then
    return nil
  end
  -- local spec = { src = 'https://github.com/' .. self[1] .. '.git' }
  local spec = { src = 'https://git::@github.com/' .. self[1] .. '.git' }
  -- HACK: remove this once default branches become `main`
  spec.version = vim.startswith(self[1], 'nvim-treesitter') and 'main' or nil
  spec.name = self.name
  spec.data = self.data
  return spec
end

--- Call the `Plugin`'s `config` function if it exists, otherwise
--- call the named module's `setup` function with `opts` if they exist.
--- Also schedules the `after` function if it exists.
function Plugin:_setup()
  if self.did_setup then
    return
  end
  -- PERF: only evaluate opts once
  local opts = nv.get(self.opts)
  if type(opts) == 'table' then
    local modname = self.name:gsub('%.nvim$', '')
    require(modname).setup(opts)
  elseif vim.is_callable(self.config) then
    self.config()
  end
  self:schedule_after()
  self.did_setup = true
end

--- Call the `Plugin`'s `config` function if it exists, otherwise
--- call the named module's `setup` function with `opts` they exist.
function Plugin:setup()
  if self.did_setup == false then
    if self.event or self.lazy == true then
      nv.lazyload(function()
        self:_setup()
      end, self.event)
    else
      self:_setup()
    end
    self:register_keys()
  end
end

-- TODO: this has been fixed in a recent update. revise:
-- breaks on initial install
vim.api.nvim_create_autocmd({ 'PackChanged' }, {
  callback = function(event)
    ---@type "install"|"update"|"delete"
    local kind = event.data.kind
    if kind ~= 'update' then
      return
    end
    ---@type vim.pack.Spec
    local spec = event.data.spec
    local build = spec.data and spec.data.build
    if type(build) == 'function' then
      if vim.v.vim_did_enter == 0 then
        -- TODO:
        -- defer build until after startup
        -- vim.schedule(function() build() end)
        print('Build function deferred for ' .. spec.name)
      end
      build()
      print('Build function executed for ' .. spec.name)
    elseif type(build) == 'string' then
      print('Build strings are not supported: ' .. build)
    end
  end,
})

local command = vim.api.nvim_create_user_command

-- plug commands
command('PlugUpdate', function(opts)
  local plugs = #opts.fargs > 0 and opts.fargs or nil
  vim.pack.update(plugs, { force = opts.bang })
end, {
  nargs = '*',
  bang = true,
  complete = function()
    return vim.tbl_map(function(p)
      return p.spec.name
    end, vim.pack.get())
  end,
})

command('PlugStatus', function(opts)
  local plugin = nv.is_nonempty_string(opts.fargs) and opts.fargs or nil
  vim._print(true, vim.pack.get(plugin, { info = opts.bang }))
end, {
  bang = true,
  nargs = '*',
  complete = function()
    return vim.tbl_map(function(p)
      return p.spec.name
    end, vim.pack.get())
  end,
})

command('PlugClean', function(opts)
  local plugs = #opts.fargs > 0 and opts.fargs or nv.plug.unloaded()
  vim.pack.del(plugs)
end, {
  nargs = '*',
  complete = function(_, _, _)
    return nv.plug.unloaded()
  end,
})

return setmetatable({
  get_keys = function()
    return vim.tbl_map(function(p)
      return nv.get(p)
    end, vim.tbl_values(keys))
  end,
  unloaded = function()
    return vim.tbl_map(
      function(p)
        return p.spec.name
      end,
      vim.tbl_filter(function(p)
        return not p.active
      end, vim.pack.get())
    )
  end,
}, {
  __call = function(_, k)
    return Plugin.new(k)
  end,
})
