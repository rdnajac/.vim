local M = {}

local function ptogglelist(cmd)
  local success, err = pcall(cmd)
  if not success and err then
    vim.notify(err, vim.log.levels.ERROR)
  end
end

M.togglelist = {
  {
    '<leader>xl',
    function()
      ptogglelist(vim.cmd[vim.fn.getloclist(0, { winid = 0 }).winid ~= 0 and 'lclose' or 'lopen'])
    end,
    desc = 'Location List',
  },
  {
    '<leader>xq',
    function()
      ptogglelist(vim.cmd[vim.fn.getqflist({ winid = 0 }).winid ~= 0 and 'cclose' or 'copen'])
    end,
    desc = 'Quickfix List',
  },
}

M.bslash_auto_bookmarks = function()
  local ret = {}
  local lua_root = vim.fs.joinpath(vim.fn.stdpath('config'), 'lua')
  for i, init_lua in ipairs(vim.fn.globpath(lua_root, 'nvim/**/init.lua', true, true)) do
    table.insert(ret, {
      '<Bslash>' .. i,
      function() vim.fn['edit#'](init_lua) end,
      desc = 'Edit ' .. vim.fs.dirname(vim.fs.relpath(lua_root, init_lua)),
    })
    if i == 9 then
      break
    end
  end
  return ret
end

return M
