local M = {}

--- @param opts? table table of options including `sort` key
function M.format(opts)
  -- if vim.list_contains({ 'i', 'R', 'ic', 'ix' }, vim.fn.mode()) then
  -- It's better not to compare the whole string but only the leading character(s)
  local mode = vim.fn.mode():sub(1, 1)
  if mode == 'i' or mode == 'R' then
    return 1
  end
  local this_filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ':p')
  local sort_keys = false
  if this_filename:match('snippets/') then
    sort_keys = true
  end
  -- local sort_keys = vim.bo.json_sort_keys or false
  local indent = vim.bo.expandtab and string.rep(' ', vim.o.softtabstop) or '\t'
  local lines = vim.api.nvim_buf_get_lines(0, vim.v.lnum - 1, vim.v.count, true)
  local deco = vim.json.decode(table.concat(lines, '\n'))
  local enco = vim.json.encode(deco, { indent = indent, sort_keys = sort_keys })
  local split = vim.split(enco, '\n') -- no split for single line?

  vim.api.nvim_buf_set_lines(0, vim.v.lnum - 1, vim.v.count, true, split)
  return 0
end

local function _open_file(path, mode)
  local f = io.open(path, mode)
  if not f then
    error('Could not open file: ' .. path)
  end
  return f
end

---@param path string
---@return table
M.read = function(path)
  local f = _open_file(path, 'r')
  local data = f:read('*a')
  f:close()
  return vim.json.decode(data)
end

---@param file string
---@param contents string
M.write = function(file, contents)
  vim.fn.mkdir(vim.fn.fnamemodify(file, ':h'), 'p')
  local fd = _open_file(file, 'w+')
  fd:write(contents)
  fd:close()
end

return M
