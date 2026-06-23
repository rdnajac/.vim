return function(ev)
  local ft = ev.match
  if not vim.tbl_contains(nv.treesitter.parsers, ft) then
    return
  end
  -- ts highlighting breaks vimtex and is started by default for lua
  if not vim.tbl_contains({ 'latex', 'lua' }, ft) then
    vim.treesitter.start(ev.buf)
  end
  -- enable legacy syntax since some plugins still rely on it
  if vim.tbl_contains({ 'lua', 'vim' }, ft) then
    vim.bo[ev.buf].syntax = 'ON'
  end
end
