local nv = _G.nv or require('nvim.util')

--- Describes the raw table values passed to to construct a `Plugin`.
--- Most fields are optional and most are normalized.
--- @class PluginModule
--- @field [1] string The plugin name in `user/repo` format.
--- @field enabled? boolean|fun():boolean

--- @class Plugin
--- @field [1] string The plugin name in `user/repo` format.
--- @field enabled boolean Defaults to `true`.
--- @field name string The plugin name as evauluated by `vim.pack`.
--- @field did_setup boolean Tracks if `setup()` has been called.
--- @field after? fun():nil Commands to run after the plugin is loaded.
--- @field build? string|fun():nil Callback after plugin is installed/updated.
--- @field config? boolean|fun():nil Setup fun or, if true, mod.setup({})
--- @field event? string |string[] Autocommand event(s) to lazy-load on.
--- @field ft? string|string[] Filetypes to lazy-load on.
--- @field lazy? boolean Defaults to `false`. Load on `VimEnter` if `true`.
--- @field keys? table|fun():table Keymaps to bind for the plugin.
--- @field opts? table|fun():table Options to pass to the plugin's `setup()`.
local Plugin = {}
Plugin.__index = Plugin

function Plugin.new(t)
  local self = t
  self.name = self[1]:match('[^/]+$') -- `repo` part of `user/repo`
  self.did_setup = false

  -- store things to be passed to `vim.pack.Spec.data`
  local data = {}
  data.setup = function()
    return self:setup()
  end
  data.build = self.build
  self.data = data

  return setmetatable(self, Plugin)
end

--- @return vim.pack.Spec
function Plugin:tospec()
  local spec = { src = 'https://github.com/' .. self[1] .. '.git' }
  -- HACK: remove this once default branches become `main`
  spec.version = vim.startswith(self[1], 'nvim-treesitter') and 'main' or nil
  spec.name = self.name
  spec.data = self.data
  return spec
end

function Plugin:_setup()
  if self.did_setup then
    return
  end
  local opts = nv.get(self.opts) or (self.config == true and {})
  if type(opts) ~= 'table' then -- maybe run config
    if type(self.config) ~= 'function' then
      return -- bail, nothing to do
    end
    self.config()
  else
    local modname = self.name:gsub('%.nvim$', '')
    require(modname).setup(opts)
  end
  -- either config or setup was called
  self.did_setup = true
  if vim.is_callable(self.after) then
    vim.schedule(self.after)
  end
end

--- Call the `Plugin`'s `config` function if it exists, otherwise
--- call the named module's `setup` function with `opts` they exist.
function Plugin:setup()
  if self.did_setup then
    return
  end
  -- if no lazy-loading, call setup now
  if not (self.event or self.ft or self.lazy == true) then
    return self:_setup()
  end
  local event = self.event and self.event or self.ft and 'FileType' or 'VimEnter'
  nv.lazyload(function()
    self:_setup()
  end, event, self.ft)
end

M = {
  unloaded = function()
    local names = {}
    for _, p in ipairs(vim.pack.get()) do
      if not p.active then
        names[#names + 1] = p.spec.name
      end
    end
    return names
  end,
}

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
      build()
    elseif type(build) == 'string' then
      Snacks.notify.warn('Build strings are not supported: ' .. build)
    end
  end,
})

return setmetatable(M, {
  __call = function(_, k)
    return Plugin.new(k)
  end,
})
