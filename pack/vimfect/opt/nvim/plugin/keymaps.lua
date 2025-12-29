local function ptogglelist(cmd)
  local success, err = pcall(cmd)
  if not success and err then
    vim.notify(err, vim.log.levels.ERROR)
  end
end

local keys = {
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
    icon = { icon = '' },
  },
}

-- TODO: convert to viml
local lua_root = vim.fs.joinpath(vim.fn.stdpath('config'), 'lua')
for i, init_lua in ipairs(vim.fn.globpath(lua_root, 'nvim/**/init.lua', true, true)) do
  table.insert(keys, {
    '<Bslash>' .. i,
    function()
      vim.fn['edit#'](init_lua)
    end,
    desc = 'Edit ' .. vim.fs.dirname(vim.fs.relpath(lua_root, init_lua)),
  })
  if i == 9 then
    break
  end
end

vim.schedule(function()
  -- local ok, wk = pcall(require, 'which-key')
  -- if ok and wk then
  --   return wk.add(keys)
  -- end
  for _, v in ipairs(keys) do
    vim.keymap.set('n', v[1], v[2], { desc = v.desc })
  end
end)

-- NOTE: In GUI and supporting terminals, `<C-i>` can be mapped separately from `<Tab>`
-- ...except in tmux: `https://github.com/tmux/tmux/issues/2705`
-- vim.keymap.set('n', '<C-i>', '<Tab>', { desc = 'restore <C-i>' })
