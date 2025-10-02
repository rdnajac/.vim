local rules = {
  form = {
    -- Change function form: local function <name>(...) <-> local <name> = function(...)
    local_func_to_assign = {
      regex = '^%s*local%s+function%s+([%w_.]+)%s*%(',
      transform = 'local %1 = function(',
    },
    local_assign_to_func = {
      regex = '^%s*local%s+([%w_.]+)%s*=%s*function%s*%(',
      transform = 'local function %1(',
    },
    -- Change function form: function M.<name>(...) <-> M.<name> = function(...)
    -- also handle `:` method notation
    M_func_to_assign = {
      regex = '^%s*function%s+M([.:])([%w_.]+)%s*%(',
      transform = 'M%1%2 = function(',
    },
    -- Change back: M.<name> = function(...) -> function M.<name>(...)
    M_assign_to_func = {
      regex = '^%s*M([.:])([%w_.]+)%s*=%s*function%s*%(',
      transform = 'function M%1%2(',
    },
  },
  scope = {
    local_to_M = { -- Change scope: local to module (crm)
      regex = '^%s*local%s+([%w_.]+)',
      transform = 'M.%1',
    },
    M_to_local = {
      regex = '^%s*M%.([%w_.]+)',
      transform = 'local %1',
    },
  },
}

local function check_regex()
  local matches = {}
  local line = vim.api.nvim_get_current_line()
  for rule in string.gmatch('scope form', '%S+') do
    for key, pattern in pairs(rules[rule]) do
      if line:match(pattern.regex) then
        table.insert(matches, rule .. ':' .. key)
      end
    end
  end
  if #matches == 0 then
    Snacks.notify.warn('No matching patterns found.')
  else
    dd(matches)
  end
end

local function transform(rule)
  local line = vim.api.nvim_get_current_line()
  for _, r in pairs(rules[rule]) do
    print(r.regex)
    if line:match(r.regex) then
      local new = line:gsub(r.regex, r.transform)
      return vim.api.nvim_set_current_line(new)
    end
  end
end

-- stylua: ignore start
vim.keymap.set('n', 'crr', check_regex, { buffer = true, desc = 'print matched regex keys' })
vim.keymap.set('n', 'crf', function() transform('form') end, { buffer = true, desc = 'local fn = function() <-> local function f()' })
vim.keymap.set('n', 'crm', function() transform('scope') end, { buffer = true, desc = 'local var = <-> M.var = ' })
vim.keymap.set('n', 'crM', 'crfcrm', { buffer = true, remap = true, desc = 'M.fn = function() --> local function fn()' })
vim.keymap.set('n', 'crF', 'crmcrf', { buffer = true, remap = true, desc = 'local function fn() --> M.fn = function()' })
-- stylua: ignore end

local function fn()
  -- FIXME:
  -- crm on `local function toggle_scope(line)`
  -- returns `M.function toggle_scope(line)`
  -- instead of `M.toggle_scope = function(line)`
  print('')
end
