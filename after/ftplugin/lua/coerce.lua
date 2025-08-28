-- `.`   (a dot) represents all characters.
-- `%a`  represents all letters.
-- `%c`  represents all control characters.
-- `%d`  represents all digits.
-- `%l`  represents all lowercase letters.
-- `%p`  represents all punctuation characters.
-- `%s`  represents all space characters.
-- `%u`  represents all uppercase letters.
-- `%w`  represents all alphanumeric characters.
-- `%x`  represents all hexadecimal digits.
-- `%z`  represents the character with representation `0`.
-- `%x`  (where `x` is any non-alphanumeric character) represents the
--     character `x`. This is the standard way to escape the magic
--     characters. Any punctuation character (even the non-magic) can be
--     preceded by a `%` when used to represent itself in a pattern.
-- NOTE: The corresponding capital letters represent the opposite set...

-- pattern items
-- `*`  0 or more
-- `+`  at least 1
-- `-`  like `*` but shortest possible match
-- `?`  0 or 1 matches

-- other things to remember
-- `^`  start of line
-- `$`  end of line

local local_patterns = {
  -- Change scope: local to module (crm)
  scope_to_module = {
    regex = '^%s*local%s+([%w_.]+)',
    transform = 'M.%1',
  },
  -- Change function form: local function <name>(...) <-> local <name> = function(...)
  func_to_assign = {
    regex = '^%s*local%s+function%s+([%w_.]+)%s*%(',
    transform = 'local %1 = function(',
  },
  assign_to_func = {
    regex = '^%s*local%s+([%w_.]+)%s*=%s*function%s*%(',
    transform = 'local function %1(',
  },
}

local module_patterns = {
  -- Change scope: module to local (crm)
  scope_to_local = {
    regex = '^%s*M%.([%w_.]+)',
    transform = 'local %1',
  },
  -- Change function form: function M.<name>(...) <-> M.<name> = function(...)
  func_to_assign = {
    regex = '^%s*function%s+M%.([%w_.]+)%s*%(',
    transform = 'M.%1 = function(',
  },
  assign_to_func = {
    regex = '^%s*M%.([%w_.]+)%s*=%s*function%s*%(',
    transform = 'function M.%1(',
  },
}

local function check_regex()
  local line = vim.api.nvim_get_current_line()
  local matches = {}
  for key, pattern in pairs(local_patterns) do
    if line:match(pattern.regex) then
      table.insert(matches, 'local:' .. key)
    end
  end
  for key, pattern in pairs(module_patterns) do
    if line:match(pattern.regex) then
      table.insert(matches, 'module:' .. key)
    end
  end
  if #matches == 0 then
    Snacks.notify.error('No matching patterns found in the current line.')
  else
    Snacks.notify.info('Matched patterns: ' .. table.concat(matches, ', '))
  end
end

local function modify_cur_line(fn)
  local line = vim.api.nvim_get_current_line()
  local out = fn(line)
  if out and out ~= line then
    vim.api.nvim_set_current_line(out)
  end
end

local function toggle_func_form(line)
  local rules = {
    local_patterns.func_to_assign,
    local_patterns.assign_to_func,
    module_patterns.func_to_assign,
    module_patterns.assign_to_func,
  }
  for _, r in ipairs(rules) do
    if line:match(r.regex) then
      return line:gsub(r.regex, r.transform)
    end
  end
  return nil
end

local function toggle_scope(line)
  local rules = {
    local_patterns.scope_to_module,
    module_patterns.scope_to_local,
  }
  for _, r in ipairs(rules) do
    if line:match(r.regex) then
      return line:gsub(r.regex, r.transform)
    end
  end
  return nil
end

vim.keymap.set('n', 'crr', check_regex, { buffer = true, desc = 'print matched regex keys' })

vim.keymap.set('n', 'crf', function()
  modify_cur_line(toggle_func_form)
end, { buffer = true, desc = 'toggle func form' })

vim.keymap.set('n', 'crm', function()
  modify_cur_line(toggle_scope)
end, { buffer = true, desc = 'toggle local<->M' })

vim.keymap.set(
  'n',
  'crM',
  'crfcrm',
  { buffer = true, remap = true, desc = 'toggle func form and scope' }
)

-- FIXME:
-- crm on `local function toggle_scope(line)`
-- returns `M.function toggle_scope(line)`
-- instead of `M.toggle_scope = function(line)`
