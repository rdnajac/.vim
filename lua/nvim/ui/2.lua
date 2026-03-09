-- XXX: unstable features!
vim.o.cmdheight = 0

-- BUG: ui2 freaks out if startup is interrupted
-- BUG: `msg` should inferred from cmdheight=0
require('vim._core.ui2').enable({
  msg = { target = 'msg' },
})

local goto_file = function()
  local line = vim.api.nvim_get_current_line()
  local lineno = line:match(':(%d+)') or 0
  local cfile = vim.fn.expand('<cfile>')
  vim.fn['edit#'](cfile)
  vim.cmd('normal! ' .. lineno .. 'G')
end

--- Window types each have respective filetype
--- • "cmd": The cmdline window; also used for 'showcmd', 'showmode', 'ruler', and messages if 'cmdheight' > 0.
--- • "msg": The message window; used for messages when 'cmdheight' == 0.
--- • "pager": The pager window; used for |:messages| and certain messages that should be shown in full.
--- • "dialog": The dialog window; used for prompt messages that expect user input.

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
