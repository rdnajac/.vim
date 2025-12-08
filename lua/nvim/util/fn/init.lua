-- fn/init.lua
-- build a table from all the files in this dir
-- each file returns a function, so lazily load them by
-- setting a metatable on the module table and the filename is the function
local M = vim.defaulttable(function(k)
  return require('nvim.util.fn.' .. k)
end)

--- Get all lines from a buffer
--- @param bufnr number? buffer number, defaults to current buffer
--- @return string[]|{} lines of the buffer, empty list if buffer has no lines
M.get_buf_lines = function(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  local nlines = vim.api.nvim_buf_line_count(bufnr)
  -- NOTE: indexing is zero-based and end-exclusive
  return vim.api.nvim_buf_get_lines(bufnr, 0, nlines, false)
end

---@param line number
---@param col number
---@return string
M.get_syn_name = function(line, col)
  return vim.fn.synIDattr(vim.fn.synID(line, col, 1), 'name')
end

--- Returns false if x is nil, not a string, or an empty string
---@param x any
---@return boolean
M.is_nonempty_string = function(x)
  return type(x) == 'string' and x ~= ''
end

--- Returns false if x is nil, not a list, or an empty list
---@param x any
M.is_nonempty_list = function(x)
  return vim.islist(x) and #x > 0
end

-- TODO:
M.modname = function(path)
  -- return vim.fn.fnamemodify(path, ':r:s?^.*/lua/??'):gsub('/', '.')
  return vim.fn.fnamemodify(path, ':r:s?^.*/lua/??')
end

--- Get list of submodules in a given subdirectory of `nvim/`
---@param subdir string subdirectory of `nvim/` to search
---@return string[] list of module names ready for `require()`
M.submodules = function(subdir)
  local luaroot = vim.fs.joinpath(vim.g.stdpath.config, 'lua')
  local path = vim.fs.joinpath(luaroot, 'nvim', subdir)
  local files = vim.fn.globpath(path, '*.lua', false, true)
  return vim.tbl_map(function(f)
    return f:sub(#luaroot + 2, -5)
  end, files)
end

--- Deferred redraw after `t` milliseconds (default 200ms)
---@param t number? time in ms to defer
M.defer_redraw = function(t)
  vim.defer_fn(function()
    -- vim.cmd([[redraw!]])
    -- vim.cmd.redraw({ bang = true })
    Snacks.util.redraw(vim.api.nvim_get_current_win())
  end, t or 200)
end

M.new = function()
  vim.ui.input({ prompt = 'new file: ' }, function(input)
    vim.cmd.edit(vim.fs.joinpath(vim.b.dirvish._dir, input))
  end)
end

M.extmark_leaks = function()
  local counts = {}
  for name, ns in pairs(vim.api.nvim_get_namespaces()) do
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      local count = #vim.api.nvim_buf_get_extmarks(buf, ns, 0, -1, {})
      if count > 0 then
        counts[#counts + 1] = {
          name = name,
          buf = buf,
          count = count,
          ft = vim.bo[buf].ft,
        }
      end
    end
  end
  table.sort(counts, function(a, b)
    return a.count > b.count
  end)
  dd(counts)
end

M.is_curwin = function()
  return vim.fn.win_getid() ~= vim.g.statusline_winid
end

return M

-- vim: fdm=expr fdl=0 fml=1
