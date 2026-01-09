local M = {}

-- local function format_lines(content)

--- @param opts? table table of options including `sort` key
function M.format(opts)
  -- if vim.list_contains({ 'i', 'R', 'ic', 'ix' }, vim.fn.mode()) then
  -- It's better not to compare the whole string but only the leading character(s)
  local mode = vim.fn.mode():sub(1, 1)
  if mode == 'i' or mode == 'R' then
    return 1
  end
  local this_filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ':p')
  local sort_keys = vim.b.sort_keys == 1
  if this_filename:match('snippets/') then
    sort_keys = true
  end
  -- local sort_keys = vim.bo.json_sort_keys or false
  local indent = vim.bo.expandtab and (' '):rep(vim.o.shiftwidth) or '\t'
  local lines = vim.api.nvim_buf_get_lines(0, vim.v.lnum - 1, vim.v.count, true)
  local lines = vim.api.nvim_buf_get_lines(0, vim.v.lnum - 1, vim.v.lnum + vim.v.count - 1, true)
  local o = vim.json.decode(table.concat(lines, '\n'))
  local stringified = vim.json.encode(o, { indent = indent, sort_keys = false })
  lines = vim.split(stringified, '\n')
  vim.api.nvim_buf_set_lines(0, vim.v.lnum - 1, vim.v.count, true, lines)
  return 0
end

---@param filename string
---@return table
M.read = function(filename) return vim.json.decode(nv.file.read(filename)) end

---@param filename string
---@param contents string|string[]
M.write = function(filename, contents)
  return require('nvim.util.file').write_lines(
    filename,
    vim.split(vim.json.encode(contents, { indent = '\t', sort_keys = false }), '\n')
  )
end

return M
