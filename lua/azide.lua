-- azide.nvim: navigate your filesystem with `n3`-like keybindings in Neovim
-- using `nvim.oil` and `zoxide`. Powered by `Snacks`.

local M = {}

---@type table<string, snacks.win>
local edgebars = {}

---@type snacks.win.Config
local opts = {
  position = 'left',
  width = 0.25,
  enter = true,
  show = false,
  on_win = function()
    vim.cmd('Oil')
  end,
  keys = {
    {
      '<leader>e',
        function(self)
          self:hide()
        end,
    },
  },
}

---@return snacks.win
function M.open()
  local win = Snacks.win(opts)
  win:on("BufWipeout", function()
    edgebars["edgebar"] = nil
  end, { buf = true })
  edgebars["edgebar"] = win
  win:show()
  return win
end

---@return snacks.win, boolean
function M.get()
  local win = edgebars["edgebar"]
  local created = false
  if not (win and win:buf_valid()) then
    win = M.open()
    created = true
  end
  return win, created
end

function M.toggle()
  local win, created = M.get()
  return created and win or win:toggle()
end

vim.keymap.set("n", "<leader>e", function()
  M.toggle()
end, { desc = "Toggle Edgebar" })

return M
