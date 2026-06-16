local M = {}

M.captures = {
  local_var = '^%s*local ([%w_.]+)%s*=',
  vim_g_var = 'vim%.([gbwtv])%.([%w_]+',
  vim_var = '([gbwtv])%:([%w_]+)',
  local_fun = '^%s*local%s+function%s+([%w_.]+)%s*%(',
  local_foo = '^%s*local%s+([%w_.]+)%s*=%s*function%s*%(',
  M_dot_foo = '^%s*M%.([%w_.]+)%s*=',
  function_M_dot = '^%s*function%s+M([.:])([%w_.]+)%s*%(',
  M_dot_foo_fun = '^%s*M([.:])([%w_.]+)%s*=%s*function%s*%(',
}

local function capture(line)
  for name, pattern in pairs(M.captures) do
    local captures = { string.match(line, pattern) }
    if #captures > 0 then
      return name, captures
    end
  end
  return nil, nil
end

--   func_to_assign = {
--     regex = '^%s*local%s+function%s+([%w_.]+)%s*%(',
--     transform = 'local %1 = function(',
--   },
--   assign_to_func = {
--     regex = '^%s*local%s+([%w_.]+)%s*=%s*function%s*%(',
--     transform = 'local function %1(',
--   },
-- }
--
-- M.module_patterns = {
--   scope_to_local = {
--     regex = '^%s*M%.([%w_.]+)%s*=',
--     transform = 'local %1 =',
--   },
--   func_to_assign = {
--     regex = '^%s*function%s+M([.:])([%w_.]+)%s*%(',
--     transform = 'M%1%2 = function(',
--   },
--   assign_to_func = {
--     regex = '^%s*M([.:])([%w_.]+)%s*=%s*function%s*%(',
--     transform = 'function M%1%2(',
--   },
-- }

--   M.local_patterns.func_to_assign,
--   M.local_patterns.assign_to_func,
--   M.module_patterns.func_to_assign,
--   M.module_patterns.assign_to_func,
--   M.local_patterns.scope_to_module,
--   M.module_patterns.scope_to_local,
--   M.vim_patterns.lua_to_vimscript,
--   M.vim_patterns.vimscript_to_lua,
-- M.formats = {
--   require = function(module) return ([[require('%s')]]):format(module) end,
--   require_func = function(module)
--     local word = vim.trim(vim.fn.expand('<cword>'))
--     return word == '' and ([[require('%s')]]):format(module) or ([[require('%s').%s()]]):format(module, word)
--   end,
-- }
--
-- return M
