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

-- regex patterns for toggling function forms and scopes in Lua
local regex = {
  local_function = '^%s*local%s+function%s+([%w_.]+)%s*%(',
  local_assign = '^%s*local%s+([%w_.]+)%s*=%s*function%s*%(',
  local_head = '^%s*local%s+([%w_]+)',
  m_def = '^%s*function%s+M%.([%w_.]+)%s*%(',
  m_assign = '^%s*M%.([%w_.]+)%s*=%s*function%s*%(',
  m_head = '^%s*M%.([%w_]+)',
}

local transform = {
  local_function = 'local %1 = function(',
  local_assign = 'local function %1(',
  m_def = 'M.%1 = function(',
  m_assign = 'function M.%1(',
  local_head_to_m = 'M.%1',
  m_head_to_local = 'local %1',
  local_fun_def_to_m = 'function M.%1(',
  m_fun_def_to_local = 'local function %1(',
}

local function check_regex()
  local line = vim.api.nvim_get_current_line()
  local matches = {}
  for key, pattern in pairs(regex) do
    if line:match(pattern) then
      table.insert(matches, key)
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
    { regex.local_function, transform.local_function },
    { regex.local_assign, transform.local_assign },
    { regex.m_def, transform.m_def },
    { regex.m_assign, transform.m_assign },
  }
  for _, r in ipairs(rules) do
    if line:match(r[1]) then
      return line:gsub(r[1], r[2])
    end
  end
  return nil
end

local function toggle_scope(line)
  local rules = {
    { regex.local_def, transform.local_fun_def_to_m },
    { regex.local_assign, transform.local_head_to_m },
    { regex.local_head, transform.m_assign },
    { regex.m_def, transform.m_fun_def_to_local },
    { regex.m_assign, transform.local_assign },
    { regex.m_head, transform.m_head_to_local },
  }
  for _, r in ipairs(rules) do
    if line:match(r[1]) then
      return line:gsub(r[1], r[2])
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
