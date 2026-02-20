local NEOVIM = {
  '███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗',
  '████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║',
  '██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║',
  '██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║',
  '██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║',
  '╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝',
  --1234567890123456789012345678901234567890
}

-- use vim list splice to remove the e and o
-- e starts at 11 and ends at +17
local header = function(cols)
  if not cols or cols > 56 then
    return table.concat(NEOVIM, '\n')
  end
  return vim
    .iter(NEOVIM)
    :map(function(line)
      -- PERF: use lua?
      local n = vim.fn.strcharpart(line, 0, 10)
      -- if cols < 20 then
      return n .. vim.fn.strcharpart(line, 27) -- nvim
      -- return n .. vim.fn.strcharpart(line, 27, 9) -- nv
    end)
    :join('\n')
end

return header
