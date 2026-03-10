-- BUG: `msg` should inferred from cmdheight=0
vim.o.cmdheight = 0
-- BUG: ui2 freaks out if startup is interrupted
require('vim._core.ui2').enable({
  msg = { target = 'msg' },
})

--- Window types each have respective filetype
--- • `cmd`: cmdline window; 'showcmd', 'showmode', 'ruler', and messages if 'cmdheight' > 0.
--- • `msg`: messages when 'cmdheight' == 0.
--- • `pager`: used for |:messages| and certain messages that should be shown in full
--- • `dialog`: used for prompt messages that expect user input

local goto_file = function()
  local line = vim.api.nvim_get_current_line()
  local lineno = line:match(':(%d+)') or 0
  local cfile = vim.fn.expand('<cfile>')
  vim.fn['edit#'](cfile)
  vim.cmd('normal! ' .. lineno .. 'G')
end

vim.api.nvim_create_autocmd({ 'FileType' }, {
  pattern = { 'msg', 'pager' },
  -- group = aug,
  callback = function()
    vim.treesitter.start(0, 'markdown')
    vim.wo.conceallevel = 3
    vim.keymap.set('n', '<CR>', goto_file, { buffer = true, desc = 'Go to file under cursor' })
  end,
  desc = '',
})
