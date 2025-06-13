-- azide.nvim: navigate your filesystem with `n3`-like keybindings in Neovim
-- using `nvim.oil` and `zoxide`. Powered by `Snacks`.

dd('adzide.nvim: loading edgebar')
---@type table<string, snacks.win>
local edgebar

---@type snacks.win.Config
local opts = {
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

edgebar = Snacks.win(opts)

local M = {}

function M.open()
  if not edgebar or edgebar.closed then
    edgebar = Snacks.win(opts)
    return edgebar, true
  end
  return edgebar, false
end

function M.toggle()
  local win, created = M.open()
  return created and win or assert(win):toggle()
end

vim.api.nvim_create_user_command('Azide', function()
  M.toggle()
end, { desc = 'Toggle Edgebar' })

vim.keymap.set('n', '<leader>e', '<Cmd>Azide<CR>')

return M
