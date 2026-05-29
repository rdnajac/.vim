local index = vim.fn.expand('$VIMRUNTIME/doc/index.txt')
-- local options = vim.fn.expand('$VIMRUNTIME/doc/options.txt')

local M = {
  cmd = {},
  abr = {},
}

function M.command_abbrevations()
  for line in io.lines(index) do
    local cmd, abr = line:match('^|:(%w+)|%s+:(%w+).*$')
    if cmd and abr then
      M.cmd[cmd] = abr
      M.abr[abr] = cmd
    end
  end
end

return M
