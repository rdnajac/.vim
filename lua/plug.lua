---@class Plugin
---@field [1] string `owner/repo`
---@field src? string derived from [1] if missing
---@field name? string derived from [1] if missing
---@field version? string|vim.VersionRange
---@field branch? string alias for `version`
---@field build? string|fun(ev: table):nil Callback after plugin is installed/updated.
---@field init? fun():nil
---@field opts? table|fun():table passed to the plugin's `setup()`
---@field keys? table|fun():table flexible keymap definitions
---@field toggle? table<string, string|table> Snacks.nvim toggles to register.
---@field event? string|string[] event on which to call `init()`
---@field lazy? boolean whether to defer `packadd()` on startup -- TODO:
local Plugin = {}
Plugin.__index = Plugin

local validate = vim.validate

--- Create a new Plugin instance from a specification table.
---@param v string|table table with required `[1]` field (or just `user/repo`
---@return Plugin
function Plugin.new(v)
  local self = type(v) == 'table' and v or { v } ---@type Plugin
  validate('[1]', self[1], 'string')
  validate('build', self.build, { 'string', 'function' }, true)
  validate('event', self.event, { 'string', 'table' }, true)
  validate('init', self.init, 'function', true)
  validate('lazy', self.lazy, 'boolean', true)
  validate('opts', self.opts, { 'table', 'function' }, true)
  validate('keys', self.keys, { 'table', 'function' }, true)
  validate('toggle', self.toggle, 'table', true)
  -- add required fields and defaults
  self.src = self.src or ('https://github.com/%s.git'):format(self[1])
  self.name = self.name or (self[1]):match('[^/]*$')
  self.version = self.version or self.branch or nil
  return setmetatable(self, Plugin)
end

-- gets a value that may be the result of a function or a static value
local function resolve(v) return vim.is_callable(v) and v() or v end

--- Assumes the plugin has a `setup()` function and calls it with `opts` if provided.
--- The module name is just the plugin name without a `.nvim` suffix, if present.
function Plugin:setup()
  if self.init then
    self.init()
  else
    local opts = resolve(self.opts)
    if type(opts) == 'table' then
      require(self.name:gsub('%.nvim$', '')).setup(opts)
    end
  end
  -- assuming keys are a list of { mode, lhs, rhs, opts? } or a function returning such a list
  local keys = resolve(self.keys)
  if vim.islist(keys) then
    vim.iter(keys):map(unpack):each(vim.keymap.set)
  end
  if self.toggle and Snacks then
    vim.iter(self.toggle):each(function(k, v) Snacks.toggle.new(v):map(k) end)
  end
end

---@class plug.Data passed as `spec.data` to `vim.pack.add()`
---@field build? string|fun():nil Callback after plugin is installed/updated.
---@field init? fun():nil called inside of the `load()` function, after `packadd()`.

local aug = vim.api.nvim_create_augroup('2lazy4lazy', {})

--- Convert the plugin to a format compatible with `vim.pack.add()`.
---@return vim.pack.Spec
function Plugin:package()
  local spec = { src = self.src, name = self.name, version = self.version }
  spec.data = { ---@type plug.Data
    build = self.build,
    init = function()
      -- _G.setup_count = _G.setup_count + 1
      return self.event
          and vim.api.nvim_create_autocmd(self.event, {
            callback = function() self:setup() end,
            group = aug,
            -- nested = true,
            once = true,
          })
        or self:setup()
    end,
  }
  return spec
end

--- Overrides `packadd`ing in `vim.pack.add`, then calls the plugin's `init()`
---@param plug_data { spec: vim.pack.Spec, path: string }
local _load = function(plug_data)
  local spec = plug_data.spec
  vim.cmd.packadd({ spec.name, bang = vim.v.vim_did_enter == 0 })
  local init = vim.tbl_get(spec, 'data', 'init')
  return vim.is_callable(init) and init() or nil
end

vim.api.nvim_create_autocmd({ 'PackChanged' }, {
  desc = 'build plugins',
  callback = function(ev)
    local kind = ev.data.kind ---@type "install"|"update"|"delete"
    local spec = ev.data.spec ---@type vim.pack.Spec
    local name = spec.name
    local build = vim.tbl_get(spec, 'data', 'build')
    if kind == 'delete' or not build then
      return
    end
    if not ev.data.active then
      vim.cmd.packadd(name)
    end
    if type(build) == 'function' then
      build()
      print('Build function called for ' .. name)
    elseif type(build) == 'string' then
      -- trim leading ':' or '<Cmd>' and trailing '<CR>'
      build = vim.trim(build):gsub('^:', ''):gsub('^<[Cc][Mm][Dd]>', ''):gsub('<[Cc][Rr]>$', '')
      vim.cmd(build)
      print('Build string executed for ' .. name)
    end
  end,
})

vim.schedule(function()
  --- Helper function to get plugin names for command completion.
  ---@param active boolean? filter by active/inactive plugins, or return all if nil
  ---@return string[] sorted list of plugin names
  local function spec_names(active)
    local names = vim
      .iter(vim.pack.get())
      :filter(function(p) return active == nil or p.active == active end)
      :map(function(p) return p.spec.name end)
      :totable()
    table.sort(names)
    return names
  end

  local subcmds = {
    clean = function(args, bang) vim.pack.del(args or spec_names(false)) end,
    get = function(args, bang) vim.pack.get(args, { info = bang }) end,
    status = function(args, bang) vim.pack.update(args, { offline = not bang }) end,
    update = function(args, bang) vim.pack.update(args, { force = bang }) end,
  }

  vim.api.nvim_create_user_command('Plug', function(opts)
    local subcmd = opts.fargs[1] or 'status'
    local args = #opts.fargs > 1 and vim.list_slice(opts.fargs, 2) or nil
    local fn = subcmds[subcmd]
    if fn then
      fn(args, opts.bang)
    else
      vim.notify('[Plug] bad subcommand: ' .. subcmd, vim.log.levels.ERROR)
    end
  end, {
    nargs = '*',
    bang = true,
    complete = function(ArgLead, CmdLine, CursorPos)
      local args = vim.split(CmdLine, '%s+', { trimempty = true })
      local num_args = #args - (vim.endswith(CmdLine, ' ') and 0 or 1)

      -- first arg is subcommand
      if num_args == 1 then
        return vim
          .iter(vim.spairs(subcmds))
          :map(function(cmd, _) return vim.startswith(cmd, ArgLead) and cmd end)
          :totable()
      end

      -- second arg is (filtered) plugin names
      local subcmd = args[2]
      local loaded = subcmd == 'clean' and false or subcmd == 'status' and nil or true
      return subcmds[subcmd] and spec_names(loaded) or {}
    end,
  })
end)

--- Wraps instantiation, initialization, and conversion, skipping disabled plugins.
---@param plugs string|Plugin|(string|Plugin)[]  list of plugin specs or single spec (string or table)
return function(plugs)
  local speclist = vim
    .iter(vim.islist(plugs) and plugs or { plugs })
    :filter(function(v) return v.enabled ~= false end)
    :map(function(v) return Plugin.new(v):package() end)
    :totable()
  vim.pack.add(speclist, { load = _load })
end
