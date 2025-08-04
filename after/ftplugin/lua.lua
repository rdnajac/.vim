local regex = {
  -- `local function foo()`
  local_def = '^%s*local%s+function%s+([%w_.]+)%s*%(',

  -- `foo = function()`
  local_assign = '^%s*local%s+([%w_.]+)%s*=%s*function%s*%(',

  -- `M.foo = function()`
  m_def = '^%s*function%s+M%.([%w_.]+)%s*%(',

  -- `M.foo = function()`
  m_assign = '^%s*M%.([%w_.]+)%s*=%s*function%s*%(',

  -- `local foo`
  local_head = '^%s*local%s+([%w_]+)',

  -- `M.foo`
  mod_head = '^%s*M%.([%w_]+)',
}

local transform = {
  local_def = 'local %1 = function(',
  m_def = 'M.%1 = function(',
  local_assign = 'local function %1(',
  m_assign = 'function M.%1(',

  local_head_to_m = 'M.%1',
  m_head_to_local = 'local %1',
}

--- Edits a line in a buffer using a transformation function.
---@param fn fun(line: string): string? The transformation function
local function modify_cur_line(fn)
  local line = vim.api.nvim_get_current_line()
  local out = fn(line)

  if out and out ~= line then
    vim.api.nvim_set_current_line(out)
  end
end

-- Transform function: toggles between `local function foo` and `foo = function`
---@param line string
---@return string|nil
local fun_form = function(line)
  local rules = {
    { regex.local_def, transform.local_def },
    { regex.local_assign, transform.local_assign },
    { regex.m_def, transform.m_def },
    { regex.m_assign, transform.m_assign },
  }

  for _, r in ipairs(rules) do
    if line:match(r[1]) then
      local ret = line:gsub(r[1], r[2])
      return ret
    end
  end
  return nil
end

-- Transform function: toggles between `local foo` and `M.foo`
---@param line string
---@return string|nil
local local_M = function(line)
  if line:match(regex.local_head) then
    return line:gsub(regex.local_head, transform.local_head_to_mod)
  elseif line:match(regex.mod_head) then
    return line:gsub(regex.mod_head, transform.mod_head_to_local)
  end
  return nil
end

-- stylua: ignore start
vim.keymap.set('n', 'crf', function() modify_cur_line(fun_form) end, { buffer = true, desc = 'toggle func form' })
vim.keymap.set('n', 'crm', function() modify_cur_line(local_M) end, { buffer = true, desc = 'toggle local<->M' })
-- stylua: ignore end

--- Yank Lua module name or require('modname') to system clipboard
---@param with_require boolean? If true, wrap in require(...)
local function yank_modname(with_require)
  local modname = require('nvim.util.path').modname()
  if modname == '' then
    return
  end

  local text = with_require and ("require('" .. modname .. "')") or modname
  vim.fn.setreg('*', text)
  Snacks.notify('yanked lua module ' .. (with_require and '' or 'name: ') .. text)
end

-- stylua: ignore start
vim.keymap.set('n', 'ym', function() yank_modname(false) end, { buffer = true, desc = 'yank lua module name' })
vim.keymap.set('n', 'yM', function() yank_modname(true) end, { buffer = true, desc = 'yank require(...) form' })
-- stylua: ignore end
