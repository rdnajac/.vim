local bookmarks = {
  b = 'blink',
  k = 'keys',
  l = 'lsp',
  m = 'mini',
  n = 'init',
  s = 'snacks/picker',
  t = 'treesitter',
  u = 'ui',
  v = 'util',
}

return vim
  .iter(bookmarks)
  :map(function(k, v)
    return { '<Bslash>' .. k, function() vim.fn['edit#luamod']('nvim/' .. v) end, desc = k }
  end)
  :totable()
