local bookmarks = {
  b = 'nvim/blink',
  k = 'nvim/keys',
  l = 'nvim/lsp',
  p = 'plug',
  s = 'nvim/snacks/picker',
  t = 'nvim/treesitter',
  u = 'nvim/util',
}

return vim
  .iter(bookmarks)
  :map(function(k, v)
    return { [[\]] .. k, function() vim.fn['edit#luamod'](v) end, desc = v }
  end)
  :totable()
