local goto_file = function()
  local line = vim.api.nvim_get_current_line()
  local lineno = line:match(':(%d+)') or 0
  local cfile = vim.fn.expand('<cfile>')
  vim.cmd(([[split +%s %s]]):format(lineno, cfile))
end

vim.treesitter.start(0, 'lua')
vim.keymap.set('n', '<CR>', goto_file, { buffer = true, desc = 'Go to file under cursor' })
