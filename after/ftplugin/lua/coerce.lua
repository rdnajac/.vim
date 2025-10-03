local local_patterns = {
  -- match:  local var = ...
  -- turn into: M.var = ...
  scope_to_module = {
    regex = '^%s*local%s+([%w_.]+)%s*=',
    transform = 'M.%1 =',
  },
  -- match:  local function foo(...)
  -- turn into: local foo = function(...)
  func_to_assign = {
    regex = '^%s*local%s+function%s+([%w_.]+)%s*%(',
    transform = 'local %1 = function(',
  },
  -- match:  local foo = function(...)
  -- turn into: local function foo(...)
  assign_to_func = {
    regex = '^%s*local%s+([%w_.]+)%s*=%s*function%s*%(',
    transform = 'local function %1(',
  },
}

local module_patterns = {
  -- match:  M.var = ...
  -- turn into: local var = ...
  scope_to_local = {
    regex = '^%s*M%.([%w_.]+)%s*=',
    transform = 'local %1 =',
  },
  -- match:  function M.foo(...) or function M:foo(...)
  -- turn into: M.foo = function(...) or M:foo = function(...)
  func_to_assign = {
    regex = '^%s*function%s+M([.:])([%w_.]+)%s*%(',
    transform = 'M%1%2 = function(',
  },
  -- match:  M.foo = function(...) or M:foo = function(...)
  -- turn into: function M.foo(...) or function M:foo(...)
  assign_to_func = {
    regex = '^%s*M([.:])([%w_.]+)%s*=%s*function%s*%(',
    transform = 'function M%1%2(',
  },
}

local form_rules = {
  local_patterns.func_to_assign,
  local_patterns.assign_to_func,
  module_patterns.func_to_assign,
  module_patterns.assign_to_func,
}

local scope_rules = {
  local_patterns.scope_to_module,
  module_patterns.scope_to_local,
}

local function apply(line, rules)
  for _, r in ipairs(rules) do
    if line:match(r.regex) then
      return line:gsub(r.regex, r.transform)
    end
  end
end

local function make(rules)
  return function()
    local line = vim.api.nvim_get_current_line()
    local out = apply(line, rules)
    if out and out ~= line then
      vim.api.nvim_set_current_line(out)
    end
  end
end

local form = make(form_rules)
local scope = make(scope_rules)

local function nmap(lhs, rhs, desc)
  vim.keymap.set('n', lhs, rhs, { buffer = true, desc = desc })
end

nmap('crf', form, 'local function fn() ↔ local fn = function()')
nmap('crm', scope, 'local x ↔ M.x')
-- stylua: ignore start
nmap('crM', function() form(); scope() end, 'local function foo() → M.foo = function()')
nmap('crF', function() scope(); form() end, 'M.foo = function() → local function foo()')
--stylua: ignore end
