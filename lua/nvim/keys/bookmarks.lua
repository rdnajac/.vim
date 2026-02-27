-- TODO: bookmarks to vim help pages
local _bookmarks = {
  b = 'blink',
  g = 'plug',
  k = 'keys',
  l = 'lsp',
  m = 'mini',
  n = 'init', -- FIXME: no init.lua
  s = 'snacks.picker',
  p = '_plugins', -- FIXME: no init.lua
  t = 'treesitter',
  u = 'ui',
  v = 'util',
}
local bookmarks = {}
for k, v in pairs(_bookmarks) do
  bookmarks[#bookmarks + 1] =
    { '<Bslash>' .. k, function() vim.fn['edit#luamod']('nvim/' .. v) end, desc = k }
  bookmarks[#bookmarks + 1] =
    { '<Bslash>' .. k:upper(), '<Cmd>edit ~/.config/nvim/lua/nvim/' .. v .. '/init.lua<CR>' }
end

return bookmarks
