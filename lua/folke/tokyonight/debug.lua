local M = setmetatable({}, {
  __call = function(M, ...) return M.debug(...) end,
})

function M.debug()
  local this_file = debug.getinfo(1, 'S').source:sub(2)
  local this_dir = vim.fs.abspath(vim.fs.dirname(this_file))
  print('Writing debug files to: ' .. this_dir)
  for _, name in ipairs({ 'colors', 'groups', 'opts' }) do
    local t, fname = M[name], vim.fs.joinpath(this_dir, 'gen', name .. '.json')

    local i = 1
    if name == 'opts' then
      -- go though the table and replace functions with the string <function %d> and count inside theat func
      local function replace_functions(tbl)
        for k, v in pairs(tbl) do
          if type(v) == 'function' then
            tbl[k] = '<function ' .. i .. '>'
            i = i + 1
          elseif type(v) == 'table' then
            replace_functions(v)
          end
        end
      end
      replace_functions(t)
    end
    -- nv.file.write(vim.fs.joinpath(this_dir, 'gen', name .. '.lua'), 'return ' .. vim.inspect(M[name]))
    nv.json.write(fname, t)
  end
end

return M
