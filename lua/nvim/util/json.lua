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

---@param filename string
---@return table
M.read = function(filename)
  return vim.json.decode(nv.file.read(filename))
end

---@param filename string
---@param contents string
M.write = function(filename, contents)
  return nv.file.write(filename, vim.json.encode(contents))
end

return M
