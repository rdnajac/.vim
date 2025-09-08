vim.g.plug_home = vim.fs.joinpath(vim.fn.stdpath('data'), 'site', 'pack', 'core', 'opt')

local user_repo_regex = '^[%w._-]+/[%w._-]+$'

local function is_nonempty_string(x)
  return type(x) == 'string' and x ~= ''
end

local function gh(user_repo)
  if is_nonempty_string(user_repo) and user_repo:match(user_repo_regex) then
    return 'https://github.com/' .. user_repo .. '.git'
  end
  return user_repo
end

--- @param p string plugin (`user/repo`)
local function to_spec(p)
  return {
    src = gh(p),
    name = p:match('([^/]+)$'):gsub('%.nvim$', ''),
    version = p:match('treesitter') and 'main' or nil,
    data = p:match('treesitter') and nil or { needs_config = true },
  }
end

local M = {}

M.spec = to_spec 

--- @return vim.pack.Spec
function M.plug(m)
  local mod = require('util').safe_require('nvim.' .. m)
  if not mod then
    return
  end

  local ret
  local spec = mod[1] and to_spec(mod[1]) or nil -- spec is a table
  if spec then
    ret = vim.tbl_map(gh, vim.list_extend({ spec }, mod.specs or {}))
  else
    ret = vim.tbl_map(to_spec, mod.specs or {})
  end
  return ret
end

function M.end_()
end

return setmetatable(M, {
  __call = function(_, plugin)
    return M.plug(plugin)
  end,
})
