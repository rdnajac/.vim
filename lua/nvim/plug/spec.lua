--- @class Plugin
--- @field [1]? string
--- @field build? string|fun(): nil
--- @field config? fun(): nil
--- @field event? vim.api.keyset.events|vim.api.keyset.events[]
--- @field enabled? boolean|fun():boolean
--- @field ft? string|string[]
--- @field opts? table|fun():table
--- @field specs? string[]|fun():string[]
local Plugin = {}
Plugin.__index = Plugin

--- Determine if the plugin is enabled.
function Plugin:is_enabled()
  if vim.is_callable(self.enabled) then
    ---@diagnostic disable-next-line: param-type-mismatch
    local ok, res = pcall(self.enabled)
    return ok and res
  end
  return self.enabled ~= false
end

--- Call the plugin's `config` function if it exists, otherwise
--- call the plugin's `setup` function with `opts` if it exists.
--- If `opts` is a function, call it to get the options table.
--- If neither `config` nor `opts` exist, call `setup` with an empty table.
--- Assumes the plugin has already been loaded with `packadd`.
function Plugin:setup()
  if vim.is_callable(self.config) then
    -- info('configuring ' .. self.name)
    self.config()
  else
    local opts = self.opts
    if vim.is_callable(opts) then
      opts = opts()
    end
    -- info('setting up ' .. self.name)
    require(self.name).setup(opts or {})
  end
end

--- If there are any dependencies, `vim.pack.add()` them
--- Dependencies are not initialized or configured, just installed
--- and are assumed to be in the form `user/repo`
function Plugin:deps()
  local specs = self.specs
  if vim.is_callable(specs) then
    specs = specs()
  end
  if type(self.specs) == 'table' and #self.specs > 0 then
    vim.pack.add(vim.tbl_map(require('nvim.plug').gh, specs), { confirm = false })
  end
end

function Plugin:init()
  self:setup()
  self:deps()
end

function Plugin.new(t)
  local self = setmetatable(t, Plugin)
  self.name = t[1]:match('[^/]+$'):gsub('%.nvim$', '')
  -- info(self.name)
  return self
end

return setmetatable(Plugin, {
  __call = function(_, t)
    return Plugin.new(t)
  end,
})
