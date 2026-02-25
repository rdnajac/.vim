local api, fn, fs = vim.api, vim.fn, vim.fs
local M = vim.defaulttable(function(k) return require('nvim.util.' .. k) end)

-- string manipulation
-- M.gh = function(s) return string.format('https://github.com/%s.git', s) end
M.capitalize = function(s) return s:sub(1, 1) .. s:sub(2):lower() end
M.camelCase = function(s)
  return s:gsub('_(%a)', function(c) return c:upper() end):gsub('^%l', string.upper)
end

-- shared
M.is_nonempty_string = function(v) return type(v) == 'string' and v ~= '' end
M.is_nonempty_list = function(v) return vim.islist(v) and #v > 0 end

-- fn wrappers
M.synname = function(row, col) return fn.synIDattr(fn.synID(row, col, 1), 'name') end


--- Normalize position arguments into a vim.Pos, falling back to cursor.
---@param ... any
---  - no args:       cursor position
---  - (row, col):    0-based integers → vim.pos(row, col)
---  - {row, col}:    extmark tuple (0-based) → vim.pos.extmark(arg)
---  - vim.Pos:       returned as-is
---@return vim.Pos
function M.pos(...)
  local nargs = select('#', ...)
  if nargs == 0 then
    return vim.pos.cursor(api.nvim_win_get_cursor(0))
  elseif nargs == 2 then
    return vim.pos(...)
  elseif nargs == 1 then
    local arg = select(1, ...)
    if type(arg) == 'table' then
      if arg.row then
        return arg
      end -- already a vim.Pos
      return vim.pos.extmark(arg) -- {row, col} extmark tuple
    end
  end
  error('pos: invalid arguments')
end
-- api wrappers
M.get_buf_lines = function(bufnr)
  bufnr = bufnr or api.nvim_get_current_buf()
  local nlines = api.nvim_buf_line_count(bufnr)
  return api.nvim_buf_get_lines(bufnr, 0, nlines, false)
end

M.is_comment = function(opts)
  opts = opts or {}
  -- opts.bufnr = opts.bufnr or api.nvim_get_current_buf()
  local pos = api.nvim_win_get_cursor(0)
  -- subtract one to account for 0-based row indexing in get_node
  local ok, node = pcall(vim.treesitter.get_node, { pos = { pos[1] - 1, pos[2] } })
  if ok and node then
    return nv.treesitter.node_is_comment(node)
  end
  -- add one to account for 1-based column indexing in synID
  return vim.startswith(M.synname({ pos[1], pos[2] + 1 }), 'Comment')
end

--- Convert a file path to a module name by trimming the lua root
---@param path string
---@return string
M.modname = function(path)
  local name = fn.fnamemodify(path, ':r:s?^.*/lua/??'):gsub('/', '.')
  return name:sub(-4) == 'init' and name:sub(1, -6) or name
end

local luaroot = fs.joinpath(vim.g.stdpath.config, 'lua')

--- Get list of submodules in a given subdirectory of `nvim/`
---@param subdir string subdirectory of `nvim/` to search
---@return string[] list of module names ready for `require()`
M.submodules = function(subdir)
  local path = fs.joinpath(luaroot, 'nvim', subdir)
  local files = fn.globpath(path, '*.lua', false, true)
  -- return vim
  --   .iter(files)
  --   :filter(function(f)
  --     if vim.fn.isdirectory(f) == 1 then
  --       return vim.uv.fs_stat(f .. '/init.lua') ~= nil
  --     else
  --       return vim.endswith(f, '.lua') and not vim.endswith(f, 'init.lua')
  --     end
  --   end)
  --  :map(M.modname)
  --  :totable()
  return vim.tbl_map(function(f) return f:sub(#luaroot + 2, -5) end, files)
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
