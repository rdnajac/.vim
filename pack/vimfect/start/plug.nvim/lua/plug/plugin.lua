local Util = require('plug.util')

---@module 'snacks'

---@class Plugin
---@field [1] string The plugin name in `user/repo` format.
---@field enabled boolean Defaults to `true`.
---@field name string The plugin name as evaluated by `vim.pack`.
---@field did_setup? boolean Tracks if `setup()` has been called.
---@field after? fun():nil Commands to run after the plugin is loaded.
---@field build? string|fun():nil Callback after plugin is installed/updated.
---@field config? boolean|fun():nil Setup fun or, if true, mod.setup({})
---@field event? string |string[] Autocommand event(s) to lazy-load on.
---@field lazy? boolean Defaults to `false`. Load on `VimEnter` if `true`.
---@field keys? table|fun():table Keymaps to bind for the plugin.
---@field opts? table|fun():table Options to pass to the plugin's `setup()`.
---@field toggles? snacks.toggle.Opts[]|fun():snacks.toggle.Opts[]
---@field version? string Git tag or version to checkout.
---@field branch? string Git branch to checkout.
---@field data? any additional data to pass to `vim.pack.add()`
local Plugin = {
  did_setup = false,
  enabled = true,
}
Plugin.__index = Plugin

function Plugin.new(t)
  vim.validate('t', t, 'table')
  t = require('nvim.lazy.sanitize')(t)
  local self = setmetatable(t, Plugin)
  self.name = self[1]:match('[^/]+$') -- `repo` part of `user/repo`
  return self
end

---@class plugin.Data passed as `spec.data` to `vim.pack.add()`
---@field build? string|fun():nil Callback after plugin is installed/updated.
---@field after? fun():nil Commands to run after the plugin is loaded.

--- Convert the `Plugin` to a `vim.pack.Spec` for use with `vim.pack`.
--- Store things in the `data` field to be accessed during `vim.pack.add()`
--- like the `build` instructions and `setup` function.
---@return vim.pack.SpecResolved|nil
function Plugin:tospec()
  return self.enabled
      and {
        src = 'https://github.com/' .. self[1] .. '.git',
        version = self.version or self.branch or nil,
        name = self.name,
        data = {
          build = self.build,
          setup = function()
            return self:setup()
          end,
        },
      }
    or nil
end

--- Call the `Plugin`'s `config` function if it exists, otherwise
--- call the named module's `setup` function with `opts` they exist.
--- Also schedules the `after` function if it exists.
function Plugin:setup()
  local function setup()
    if self.did_setup then
      return
    end
    -- PERF: only evaluate opts once
    local opts = Util.get(self.opts)
    if type(opts) == 'table' then
      local modname = self.name:gsub('%.nvim$', '')
      require(modname).setup(opts)
    else -- opts probably nil, try calling config
      Util.call(self.config)
    end
    self.did_setup = true

    if vim.is_callable(self.after) then
      print(self.name)
      vim.schedule(self.after)
    end
  end

  if self.event then -- lazyload on autocmd
    require('nvim.lazy.load').on_event(self.event, setup)
  else
    setup()
  end
end

return Plugin
