local api, fn, fs = vim.api, vim.fn, vim.fs
local M = vim.defaulttable(function(k) return require('nvim.util.' .. k) end)

-- string manipulation
M.capitalize = function(s) return s:sub(1, 1):upper() .. s:sub(2):lower() end
M.camelCase = function(s)
  return s:gsub('_(%a)', function(c) return c:upper() end):gsub('^%l', string.upper)
end

-- shared
M.is_nonempty_string = function(v) return type(v) == 'string' and v ~= '' end
M.is_nonempty_list = function(v) return vim.islist(v) and #v > 0 end

-- fn wrappers
M.synname = function(row, col) return fn.synIDattr(fn.synID(row, col, 1), 'name') end

-- local luaroot = fs.joinpath(vim.g.stdpath.config, 'lua')
--- Convert a file path to a module name by trimming the lua root
---@param path string
---@return string
M.modname = function(path)
  local name = fn.fnamemodify(path, ':r:s?^.*/lua/??') -- :gsub('/', '.')
  return name:sub(-4) == 'init' and name:sub(1, -6) or name
end

-- api wrappers
M.get_buf_lines = function(bufnr)
  bufnr = bufnr or api.nvim_get_current_buf()
  local nlines = api.nvim_buf_line_count(bufnr)
  return api.nvim_buf_get_lines(bufnr, 0, nlines, false)
end

---@param opts? vim.treesitter.get_node.Opts
M.is_comment = function(opts)
  opts = opts or {}
  opts.bufnr = opts.bufnr or api.nvim_get_current_buf()
  local cursor = vim.api.nvim_win_get_cursor(0)
  -- subtract one to account for 0-based row indexing in get_node
  opts.pos = opts.pos or { cursor[1] - 1, cursor[2] }

  local ok, node = pcall(vim.treesitter.get_node, opts)
  if ok and node then
    return require('nvim.treesitter').node_is_comment(node)
  end
  -- opts.pos is 0-indexed; synID expects 1-based row and col
  return vim.startswith(M.synname(cursor[1], cursor[2] + 1), 'Comment')
end

--- foldtext for lua files with treesitter folds
---@return string
M.foldtext = function()
  local indicator = '...'
  local start = fn.getline(vim.v.foldstart)
  local end_ = fn.getline(vim.v.foldend)
  local parts = { start }

  if vim.endswith(start, '{') then
    if vim.trim(start) == '{' then -- only '{' on the line
      local second_line = vim.fn.getline(vim.v.foldstart + 1)
      local quoted_str = second_line:match('^%s*(["\']..-["\'],?)%s*$')
      parts[#parts + 1] = quoted_str
    end
    parts[#parts + 1] = indicator
  elseif vim.endswith(start, ')') or vim.endswith(start, 'do') then
    parts[#parts + 1] = indicator
  else
    return start -- return if no special handling
  end
  parts[#parts + 1] = vim.trim(end_)
  return table.concat(parts, ' ')
end

function M.yank(text)
  fn.setreg('*', text)
  print('yanked: ' .. text)
end

--- cache/read lines file in the cache directory,
--- or read lines from a file in the cache directory
---@param fname string filename relative to cache directory
---@param lines string[]|nil lines to write, or nil to read
---@return string[]? lines read from file or written to file
M.cache = function(fname, lines)
  local cache_path = fs.joinpath(vim.g.stdpath.cache, fname)
  if lines == nil and fn.filereadable(cache_path) then
    lines = fn.readfile(cache_path)
  else
    fn.mkdir(fs.dirname(cache_path), 'p')
    fn.writefile(lines, cache_path)
  end
  return lines
end

M.exec = function(cmd)
  local res = vim.api.nvim_exec2(cmd, { output = true })
  return vim.split(res.output, '\n', { trimempty = true })
end

-- local ns = vim.api.nvim_create_namespace('hl_on_paste')
-- vim.paste = (function(overridden)
--   return function(lines, phase)
--     local ret = overridden(lines, phase)
--     vim.hl.range(0, ns, 'Visual', "'[", "']", { timeout = 300 })
--     return ret
--   end
-- end)(vim.paste)

return M
