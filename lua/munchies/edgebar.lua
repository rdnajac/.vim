-- make a snacks win layout for oil buffers
local M = {}

---@type snacks.win.Config
M.opts = {
  position = 'left',
  width = 0.25,
  enter = true,
  show = false,
  on_win = function()
    vim.cmd('Oil')
  end,
  -- stylua: ignore
  keys = { { '<leader>e', function(self) self:hide() end } },
}

local win
M.toggle = function()
  if not win then
    win = Snacks.win(M.opts)
  end
  win:toggle()
end

M.init = function()
  vim.keymap.set('n', '<leader>e', function()
    require('munchies.edgebar').toggle()
  end, { desc = 'Toggle Edgebar' })
end

return M
