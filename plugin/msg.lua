local filetypes = { 'cmd', 'msg', 'pager' }

vim.treesitter.language.register('markdown', filetypes)

nv.on('FileType', { pattern = filetypes }, function(ev)
  vim.treesitter.start(ev.buf)
  vim.keymap.set('n', { 'gf', '<2-LeftMouse>' }, nv.goto_file, { buf = ev.buf, expr = true })
  vim.cmd([[
  setl conceallevel=3 
  setl winhl=@markup.strikethrough:NONE
  setl nowrap
  ]])
end)
