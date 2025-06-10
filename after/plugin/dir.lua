vim.keymap.set("n", "_", function()
  local cwd = vim.fn.getcwd()
  local target = vim.fn.expand("%:p:h")
  if cwd == target then
    target = require("lazyvim.util").root.get()
  end
  vim.cmd("cd " .. target .. " | pwd")
end)
