-- let g:plug_home = join([stdpath('data'), 'site', 'pack', 'core', 'opt'], '/')
vim.g.plug_home = vim.fs.joinpath(vim.fn.stdpath('data'), 'site', 'pack', 'core', 'opt')

-- alias plug.spec
--- Extend the `vim.pack.Spec` type with additional fields
--- @class PlugSpec
--- @field [1]? string|vim.pack.Spec
--- @field build? string|fun(): nil
--- @field config? fun(): nil
--- @field dependencies? (string|vim.pack.Spec|PlugSpec)[]
--- @field event? vim.api.keyset.events|vim.api.keyset.events[]
--- @field enabled? boolean|fun():boolean
--- @field specs? (string|vim.pack.Spec)[]
--- @field opts? table|any
local M = {}
M.__index = M

local enabled = function(plugin)
  local enabled = plugin.enabled
  if vim.is_callable(enabled) then
    local ok, res = pcall(enabled)
    return ok and res
  end
  return enabled == nil or enabled == true
end

---@param t table
---@return PlugSpec
function M.new(t)
  -- if not enabled(t) then
  --   return nil
  -- end
  return setmetatable(t, M)
end

function M:get()
  info(self)
end

--- from `~/.local/share/nvim/share/nvim/runtime/lua/vim/pack.lua`
---
--- @param x any
--- @return boolean
local function is_nonempty_string(x)
  return type(x) == 'string' and x ~= ''
end

-- user/repo can contain only letters, digits, '_', '-' and '.'
-- `%w`  represents all alphanumeric characters.
local user_repo_regex = '^[%w._-]+/[%w._-]+$'

local test = function()
  local cases = {
    'user/repo',
    'user_123/repo-1.0',
    'http://github.com/user/repo.git',
    'user/repo/extra',
    '/repo',
    'user/',
    'user!repo',
  }

  for _, case in ipairs(cases) do
    local ok = case:match(user_repo_regex) ~= nil
    print('[' .. (ok == true and 'PASS' or 'FAIL') .. '] ' .. case)
  end
end
-- test()

--- Returns the spec to pass to `vim.pack.add()`
--- Doesn't do any validation; just makes the best attempt at inferring the spec(s)
---
--- @return (string|vim.pack.Spec)[]
function M:spec()
  local t = type(self)

  -- Handle multiple specs
  if self.specs and type(self.specs) == 'table' then
    local list = {}
    for _, p in ipairs(self.specs) do
      local spec = type(p) == 'string'
          and {
            src = 'https://github.com/' .. p .. '.git',
            name = p:match('[^/]+$'):gsub('%.git$', ''),
          }
        or (p.src and p or nil)
      if spec then
        table.insert(list, spec)
      end
    end
    return list
  end

  -- Single spec
  local src = t == 'string' and self or self[1] or self.src
  if not is_nonempty_string(src) then
    error('spec.src must be a non-empty string')
  end

  if src:match(user_repo_regex) then
    src = 'https://github.com/' .. src .. (vim.endswith(src, '.git') and '' or '.git')
  end

  local spec = { src = src }

  if t == 'table' then
    spec.name = self.name or src:match('[^/]+$'):gsub('%.git$', ''):gsub('%.nvim$', '')

    spec.version = self.version or nil

    if self.config or self.opts then
      spec.data = {
        setup = function()
          if self.config and vim.is_callable(self.config) then
            self.config()
          elseif self.opts then
            require(spec.name).setup(self.opts)
          end
        end,
      }
    end
  end

  return spec
end

-- Autocmd setup for lazy configs
local aug = vim.api.nvim_create_augroup('LazyLoad', { clear = true })

-- TODO: handle ft events
function M:do_config()
  if vim.is_callable(self.config) then
    if self.event then
      vim.api.nvim_create_autocmd(self.event, {
        group = aug,
        once = true,
        callback = self.config,
      })
    else
      self.config()
    end
  end
end

return setmetatable(M, {
  __call = function(self, t)
    return M.new(t)
  end,
})
