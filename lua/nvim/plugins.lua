-- _G.nv = _G.nv or require('nvim.util')
local lazyload = require('nvim.util').lazyload
local keys = {}

--- @generic T
--- @param x T|fun():T
--- @return T
local function get(x)
  return type(x) == 'function' and x() or x
end

--- @class Plugin
--- @field [1] string The plugin name in `user/repo` format.
--- @field name string The plugin name, derived from [1]
--- @field after? fun():nil Commands to run after the plugin is loaded.
--- @field build? string|fun():nil Callback after plugin is installed/updated.
--- @field config? fun():nil Function to run to configure the plugin.
--- @field enabled? boolean
--- @field event? string
--- @field ft? string|string[] Filetypes to lazy-load on.
--- @field lazy? boolean
--- @field keys? table
--- @field opts? table|fun():table Options to pass to the plugin's `setup()`.
--- @field specs? string[] Additional plugin specs in `user/repo` format.
--- @field did_setup? boolean Tracks if `setup()` has been called.
local Plugin = {}
Plugin.__index = Plugin

--- @param t table
function Plugin.new(t)
  local self = t
  local name = t[1]:match('[^/]+$'):gsub('%.nvim$', '')
  self.name = (name == 'R') and 'r' or name
  self.enabled = get(t.enabled) ~= false
  return setmetatable(self, Plugin)
end

function Plugin:_setup()
  if self.did_setup then
    return
  end

  local setup
  if vim.is_callable(self.config) then
    setup = self.config
  else
    local opts = get(self.opts) or (self.config == true and {})
    if type(opts) == 'table' then
      setup = function()
        require(self.name).setup(opts)
      end
    end
  end

  if setup then
    setup()
    self.did_setup = true
    if vim.is_callable(self.after) then
      vim.schedule(self.after)
    end
  end
end

--- Call the `Plugin`'s `config` function if it exists, otherwise
--- call the named module's `setup` function with `opts` they exist.
function Plugin:setup()
  if not self.enabled or self.did_setup then
    return
  end
  if not (self.event or self.ft or self.lazy == true) then
    self:_setup()
  else
    lazyload(function()
      self:_setup()
    end, self.event and self.event or self.ft and 'FileType', self.ft)
  end
  keys[self.name] = get(self.keys)
end

lazyload(function()
  require('which-key').add(vim.tbl_values(keys))
end)

local specs = {}
local disabled = {}

-- stylua: ignore
M = {
  specs = function()  return vim.deepcopy(specs) end,
  disabled = function() return vim.deepcopy(disabled) end,
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

return setmetatable(M, {
  __call = function(_, k)
    local P = Plugin.new(k)
    local speclist = { P[1] }
    if vim.islist(P.specs) then
      vim.list_extend(speclist, P.specs)
    end
    vim.list_extend(P.enabled and specs or disabled, speclist)
    return P
  end,
})
