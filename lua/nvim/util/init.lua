local M = vim.defaulttable(function(k) return require('nvim.util.' .. k) end)

-- string manipulation
M.gh = function(s) return string.format('https://github.com/%s.git', s) end
M.capitalize = function(s) return s:sub(1, 1) .. s:sub(2):lower() end
M.camelCase = function(s)
  return s:gsub('_(%a)', function(c) return c:upper() end):gsub('^%l', string.upper)
end

-- boolean checks
M.is_nonempty_list = function(v) return vim.islist(v) and #v > 0 end
M.is_nonempty_string = function(v) return type(v) == 'string' and v ~= '' end
M.is_comment = function(opts)
  local ok, node = pcall(vim.treesitter.get_node, opts)
  if ok and node then
    return nv.treesitter.node_is_comment(node)
  end
  return vim.fn['comment#syntax_match']()
end

-- api
M.get_buf_lines = function(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  local nlines = vim.api.nvim_buf_line_count(bufnr)
  return vim.api.nvim_buf_get_lines(bufnr, 0, nlines, false)
end

-- fn
---@param path string
---@return string
M.modname = function(path)
  local name = vim.fn.fnamemodify(path, ':r:s?^.*/lua/??'):gsub('/', '.')
  return name:sub(-4) == 'init' and name:sub(1, -6) or name
end

-- copied from `Snacks.util`
M.defer_redraw_win = function(t)
  -- vim.defer_fn(function() Snacks.util.redraw(vim.api.nvim_get_current_win()) end, t or 200)
  vim.defer_fn(
    function()
      vim.api.nvim__redraw({ win = vim.api.nvim_get_current_win(), valid = false, flush = false })
    end,
    t or 200
  )
end

local luaroot = vim.fs.joinpath(vim.g.stdpath.config, 'lua')

--- Get list of submodules in a given subdirectory of `nvim/`
---@param subdir string subdirectory of `nvim/` to search
---@return string[] list of module names ready for `require()`
M.submodules = function(subdir)
  local path = vim.fs.joinpath(luaroot, 'nvim', subdir)
  local files = vim.fn.globpath(path, '*.lua', false, true)
  return vim.tbl_map(function(f) return f:sub(#luaroot + 2, -5) end, files)
end

--- foldtext for lua files with treesitter folds
---@returns string
M.foldtext = function()
  local indicator = '...'
  local start = vim.fn.getline(vim.v.foldstart)
  local end_ = vim.fn.getline(vim.v.foldend)
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

-- count keys used in all subtables of M
M.key_counts = function()
  local ret = {}
  for _, v in pairs(M) do
    if
      type(v) == 'table' --[[and v ~= M.key_counts]]
    then
      for key in pairs(v) do
        ret[key] = (ret[key] or 0) + 1
      end
    end
  end
  return ret
end

function M.yank(text)
  vim.fn.setreg('*', text)
  print('yanked: ' .. text)
end

-- nv.tbl_add_inverse_lookup
-- vim.tbl_add_reverse_lookup(M.kinds)
-- shared method is deprecated because it is not type safe
-- https://github.com/neovim/neovim/pull/24564

-- vim.print(vim.iter({ a='x1', b='x2', c='x3', d='x4' }):fold({}, function(t, k, v)
--   t[v] = k
--   return t
-- end))

-- local inv = {}
-- for k, v in pairs(t) do
--   inv[v] = k
-- end


return M
