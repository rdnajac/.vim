vim.g.plug_home = vim.fs.joinpath(nv.stdpath.data, 'site', 'pack', 'core', 'opt')
vim.env.PACKDIR = vim.g.plug_home
-- TODO: snacks are available; use the, here

--- Safely get a value or evaluate a function field
---@generic T
---@param field T|fun():T
---@return T?
local get = function(field)
  if type(field) == 'function' then
    local ok, res = pcall(field)
    if ok then
      return res
    else
      vim.schedule(function()
        vim.notify('Error evaluating field: ' .. tostring(res), vim.log.levels.ERROR)
      end)
      return nil
    end
  end
  return field
end

---- @param user_repo string plugin (`user/repo`)
---- @param data? any
---- @return string|vim.pack.Spec
local to_spec = function(user_repo, data)
  if not nv.is_nonempty_string(user_repo) then
    return user_repo
  end

  local src = 'https://github.com/' .. user_repo .. '.git'
  local last = user_repo:find('[^/]+$') or 1
  local name = user_repo:sub(last)
  if name:sub(-5) == '.nvim' then
    name = name:sub(1, -6)
  end

  return {
    src = src,
    name = name,
    version = user_repo:match('treesitter') and 'main' or nil,
    data = data,
  }
end

--- @class Plugin
--- @field [1]? string
--- @field after? fun():nil
--- @field build? string|fun():nil
--- @field commands? fun():nil
--- @field config? fun():nil
--- @field enabled? boolean|fun():boolean
--- @field keys? wk.Spec|fun():wk.Spec
--- @field specs? string[]
--- @field opts? table|fun():table
--- TODO: can we get it from the spec instead?
--- @field name string The plugin name, derived from [1]
local Plugin = {}
Plugin.__index = Plugin

--- @param plugin table
function Plugin.new(plugin)
  local self = plugin

  local topspec = nv.is_nonempty_string(self[1]) and to_spec(self[1])
  if topspec then
    self.name = topspec.name
    self.specs = vim.list_extend(self.specs or {}, { topspec })
  end

  return setmetatable(self, Plugin)
end

function Plugin:is_enabled()
  return get(self.enabled) ~= false
end

function Plugin:init()
  if self:is_enabled() then
    self:add()
    self:setup()
    self:do_after()
    -- self:do_build()
    self:do_commands()
    self:do_keymaps()
  else
    nv.did.disable[#nv.did.disable + 1] = self.name
  end
end

function Plugin:add()
  if nv.is_nonempty_list(self.specs) then
    local resolved_specs = vim.tbl_map(to_spec, self.specs)
    vim.pack.add(resolved_specs)
  end
end
---
--- Call the `Plugin`'s `config` function if it exists, otherwise
--- call the named module's `setup` function with `opts` they exist.
function Plugin:setup()
  local setup
  if vim.is_callable(self.config) then
    setup = self.config
  else
    local opts = get(self.opts)
    if type(opts) == 'table' then
      setup = function()
        require(self.name).setup(opts)
      end
    end
  end
  if vim.is_callable(setup) then
    nv.did.setup[self.name] = pcall(setup)
  end
end

function Plugin:do_after()
  nv.lazyload(function()
    if vim.is_callable(self.after) then
      nv.did.after[self.name] = pcall(self.after)
    end
  end)
end

function Plugin:do_build()
  if not self.build then
    return
  end

  local function notify_build(ok, err)
    local msg = string.format(
      'Build %s for %s%s',
      ok and 'succeeded' or 'failed',
      self.name,
      err and (': ' .. err) or ''
    )
    Snacks.notify(msg, ok and 'info' or 'error')
  end

  vim.api.nvim_create_autocmd('PackChanged', {
    callback = function(event)
      if event.data.kind ~= 'update' then
        return
      end

      if vim.is_callable(self.build) then
        local ok, result = pcall(self.build)
        notify_build(ok, not ok and result or nil)
      elseif nv.is_nonempty_string(self.build) then
        local build_str = self.build

        -- Ex command (e.g. ":Make", "<Cmd>make<CR>")
        if build_str:match('^:') or build_str:match('^<Cmd>') then
          build_str = build_str:gsub('^:', '')
          build_str = build_str:gsub('^<Cmd>', '')
          build_str = build_str:gsub('<CR>$', '')
          local ok, err = pcall(vim.cmd, build_str)
          notify_build(ok, not ok and err or nil)
        else
          -- Normalize leading "!" for shell commands
          build_str = build_str:gsub('^!', '')
          local cmd = string.format('cd %s && %s', vim.fn.shellescape(data.spec.dir), build_str)
          local output = vim.fn.system(cmd)
          notify_build(vim.v.shell_error == 0, vim.v.shell_error ~= 0 and output or nil)
        end
      else
        notify_build(false, 'Invalid build type: ' .. type(self.build))
      end
    end,
  })
end

function Plugin:do_commands()
  if vim.is_callable(self.commands) then
    nv.lazyload(function()
      nv.did.commands[self.name] = pcall(self.commands)
    end, 'CmdLineEnter')
  end
end

function Plugin:do_keymaps()
  local keys = get(self.keys)
  if nv.is_nonempty_list(keys) then
    nv.lazyload(function()
      local wk = require('which-key')
      nv.did.wk[self.name] = pcall(wk.add, keys)
    end)
  end
end

local dir = nv.stdpath.config .. '/lua/nvim/plugins'
local files = vim.fn.globpath(dir, '*.lua', false, true)

M = vim
  .iter(files)
  :map(function(path)
    return path:match('^.+/(.+)%.lua$')
  end)
  :filter(function(name)
    return name ~= 'init'
  end)
  :map(function(name)
    local t = require('nvim.plugins.' .. name)
    return vim.islist(t) and t or { t }
  end)
  :flatten()
  :map(function(spec)
    local P = Plugin.new(spec)
    P:init()
    return P
  end)
  :totable()

M.unloaded = function()
  return vim
    .iter(vim.pack.get())
    --- @param p vim.pack.PlugData
    :filter(function(p)
      return p.active == false
    end)
    --- @param p vim.pack.PlugData
    :map(function(p)
      return p.spec.name
    end)
    :totable()
end

return M
