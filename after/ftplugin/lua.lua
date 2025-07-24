local regex = {
  local_def = '^%s*local%s+function%s+([%w_.]+)%s*%(',
  local_assign = '^%s*local%s+([%w_.]+)%s*=%s*function%s*%(',
  mod_def = '^%s*function%s+M%.([%w_.]+)%s*%(',
  mod_assign = '^%s*M%.([%w_.]+)%s*=%s*function%s*%(',

  local_head = '^%s*local%s+([%w_]+)',
  mod_head = '^%s*M%.([%w_]+)',
}

local transform = {
  local_def = 'local %1 = function(',
  local_assign = 'local function %1(',
  mod_def = 'M.%1 = function(',
  mod_assign = 'function M.%1(',

  local_head_to_mod = 'M.%1',
  mod_head_to_local = 'local %1',
}

---@param bufnr integer
---@param lnum integer
---@param fn fun(line:string):string|nil
local function edit_line(bufnr, lnum, fn)
  local line = vim.api.nvim_buf_get_lines(bufnr, lnum, lnum + 1, false)[1]
  if not line then
    return
  end
  local out = fn(line)
  if out and out ~= line then
    vim.api.nvim_buf_set_lines(bufnr, lnum, lnum + 1, false, { out })
  end
end

local M = {}

function M.fun_form(bufnr, lnum)
  edit_line(bufnr, lnum, function(line)
    local rules = {
      { regex.local_def, transform.local_def },
      { regex.local_assign, transform.local_assign },
      { regex.mod_def, transform.mod_def },
      { regex.mod_assign, transform.mod_assign },
    }
    for _, r in ipairs(rules) do
      if line:match(r[1]) then
        return line:gsub(r[1], r[2])
      end
    end
    return nil
  end)
end

function M.local_M(bufnr, lnum)
  edit_line(bufnr, lnum, function(line)
    if line:match(regex.local_head) then
      return line:gsub(regex.local_head, transform.local_head_to_mod)
    elseif line:match(regex.mod_head) then
      return line:gsub(regex.mod_head, transform.mod_head_to_local)
    end
    return nil
  end)
end

vim.keymap.set('n', 'crf', function()
  M.fun_form(0, vim.fn.line('.') - 1)
end, { buffer = true, desc = 'toggle func form' })

vim.keymap.set('n', 'crm', function()
  M.local_M(0, vim.fn.line('.') - 1)
end, { buffer = true, desc = 'toggle local<->M' })

return M
