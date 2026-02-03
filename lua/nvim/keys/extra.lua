local function ptogglelist(cmd)
  local success, err = pcall(cmd)
  if not success and err then
    vim.notify(err, vim.log.levels.ERROR)
  end
end

local keys = {
  { 'n', 'dI', 'dai', { desc = 'Delete Indent', remap = true } },
  { '<leader>ui', '<Cmd>Inspect<CR>' },
  { '<leader>uI', '<Cmd>Inspect!<CR>' },
  {
    '<leader>uT',
    function()
      vim.treesitter.inspect_tree()
      vim.api.nvim_input('I')
    end,
    desc = 'Inspect Tree',
  },
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

local lua_root = vim.fs.joinpath(vim.fn.stdpath('config'), 'lua')
for i, init_lua in ipairs(vim.fn.globpath(lua_root, 'nvim/**/init.lua', true, true)) do
  table.insert(keys, {
    '<Bslash>' .. i,
    function() vim.fn['edit#'](init_lua) end,
    desc = 'Edit ' .. vim.fs.dirname(vim.fs.relpath(lua_root, init_lua)),
  })
  if i == 9 then
    break
  end
end

return keys
