-- fn/init.lua
-- build a table from all the files in this dir
-- each file returns a function, so lazily load them by
-- setting a metatable on the module table and the filename is the function
local M = {}

M.get_syn_name = function(line, col)
  return vim.fn.synIDattr(vim.fn.synID(line, col, 1), 'name')
end

M.is_nonempty_string = function(x)
  return type(x) == 'string' and x ~= ''
end

M.is_nonempty_list = function(x)
  return vim.islist(x) and #x > 0
end

--- @param subdir string subdirectory of `nvim/` to search
--- @return string[] list of module names ready for `require()`
M.submodules = function(subdir)
  local path = vim.fs.joinpath(vim.g.luaroot, 'nvim', subdir)
  local files = vim.fn.globpath(path, '*.lua', false, true)
  return vim.tbl_map(function(f)
    return f:sub(#vim.g.luaroot + 2, -5)
  end, files)
end

--- Deferred redraw after `t` milliseconds (default 200ms)
--- @param t number? time in ms to defer
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
  local nsn = vim.api.nvim_get_namespaces()

  local counts = {}

  for name, ns in pairs(nsn) do
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

return setmetatable(M, {
  __index = function(_, key)
    local ok, mod = pcall(require, 'nv.util.fn.' .. key)
    if ok then
      rawset(M, key, mod)
      return mod
    else
      return nil
    end
  end,
})
-- vim: fdm=expr fdl=0 fml=1
