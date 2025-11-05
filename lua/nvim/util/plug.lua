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
--- @field toggles? table
--- @field version? string Git tag or version to checkout.
--- @field branch? string Git branch to checkout.
--- @field data? any additional data to pass to `vim.pack.add()`
local Plugin = {}
Plugin.__index = Plugin

-- shared table of keys for all plugins
local keys = {}
-- local toggles = {}

function Plugin:register_keys()
  keys[self.name] = self.keys
  -- TODO:
  -- toggles[self.toggle] = self.keys
end

function Plugin:schedule_after()
  if vim.is_callable(self.after) then
    vim.schedule(self.after)
  end
end

function Plugin.new(t)
  -- print(vim.inspect(t))
  local self = setmetatable(t, Plugin)
  self.name = self[1]:match('[^/]+$') -- `repo` part of `user/repo`
  -- store things to be passed to `vim.pack.Spec.data`
  self.data = {
    build = self.build,
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

  if self.lazy == true or self.event == 'LazyFile' then
    self.event = 'VimEnter'
  end

  return self
end

--- Convert the `Plugin` to a `vim.pack.Spec` for use with `vim.pack`.
--- The `spec`'s `data` field will contain the `build` and `setup` functions.
--- @return vim.pack.Spec|nil
function Plugin:tospec()
  if self.enabled == false then
    return nil
  end
  -- local spec = { src = 'https://github.com/' .. self[1] .. '.git' }
  local spec = { src = 'https://git::@github.com/' .. self[1] .. '.git' }
  spec.version = self.version or self.branch or nil
  -- HACK: remove this once default branches become `main`
  -- spec.version = vim.startswith(self[1], 'nvim-treesitter') and 'main' or nil
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
  local opts = vim.is_callable(self.opts) and self.opts() or self.opts
  if type(opts) == 'table' then
    local modname = self.name:gsub('%.nvim$', '')
    require(modname).setup(opts)
  elseif vim.is_callable(self.config) then
    self.config()
  end
  self:schedule_after()
  self.did_setup = true
end

local aug = vim.api.nvim_create_augroup('LazyLoad', {})
--- Call the `Plugin`'s `config` function if it exists, otherwise
--- call the named module's `setup` function with `opts` they exist.
function Plugin:setup()
  if self.did_setup == false then
    if self.event then
      vim.api.nvim_create_autocmd(self.event, {
        callback = function()
          self:_setup()
        end,
        group = aug,
        -- nested = true,
        once = true,
      })
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
      if not event.data.active then
        vim.cmd.packadd(spec.name)
      end
      build()
      print('Build function executed for ' .. spec.name)
    elseif type(build) == 'string' then
      -- trim leading ':' or '<Cmd>' and trailing '<CR>'
      build = build:gsub('^:*', ''):gsub('^<[Cc][Mm][Dd]>', ''):gsub('<[Cc][Rr]>$', '')
      vim.cmd(build)
      print('Build string executed for ' .. spec.name)
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
  local plugin = nv.fn.is_nonempty_string(opts.fargs) and opts.fargs or nil
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
      return vim.is_callable(p) and p() or p
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
