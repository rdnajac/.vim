local M = {}

M.after = function()
  -- TODO: harpoon??
  -- TODO: bookmarks to vim help pages
  local _bookmarks = {
    b = 'blink',
    g = 'plug',
    k = 'keys',
    l = 'lsp',
    m = 'mini',
    n = 'init', -- FIXME: no init.lua
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
  M.map(bookmarks)
  M.map(M.togglelist)
  if not Snacks then
    return
  end
  Snacks.keymap.set('n', 'K', vim.lsp.buf.hover, { lsp = {}, desc = 'LSP Hover' })
  Snacks.keymap.set({ 'n', 'x' }, '<M-CR>', Snacks.debug.run, { ft = 'lua' })
  Snacks.util.on_key('<Esc>', function() vim.cmd.nohlsearch() end)
end

M.specs = {
  {
    'monaqa/dial.nvim',
    -- TODO: lazy load this
    event = 'UIEnter',
    init = function()
      package.preload['dial.config'] = function() return require('nvim.keys.dial') end
    end,
    keys = {
      { { 'n', 'x' }, '<C-a>', '<Plug>(dial-increment)' },
      { { 'n', 'x' }, 'g<C-a>', '<Plug>(dial-g-increment)' },
      { { 'n', 'x' }, '<C-x>', '<Plug>(dial-decrement)' },
      { { 'n', 'x' }, 'g<C-x>', '<Plug>(dial-g-decrement)' },
    },
  },
}

local modes = { 'n', 'v', 'x', 'i', 't', 'o', 'c', 's' }
local function has_mode(t) return type(t[1]) == 'table' or vim.tbl_contains(modes, t[1]) end
local function _parse(t)
  -- stylua: ignore
  if has_mode(t) then return unpack(t) end
  local lhs, rhs, opts = t[1], t[2], t[3]
  opts = type(opts) == 'table' and opts or {}
  for k, v in pairs(t) do
    if type(k) == 'string' and k ~= 'mode' then
      opts[k] = v
    end
  end
  return t.mode or 'n', lhs, rhs, opts
end

M.map = function(t) vim.iter(t):map(_parse):each(vim.keymap.set) end

---@param key string normal mode keys mapped by snacks.toggle.Class method
---@param v string|table the preset toggle name or the table of opts
M.map_snacks_toggle = function(key, v)
  local Toggle = Snacks.toggle
  if type(v) == 'table' then
    return Toggle.new(v):map(key)
  end -- XXX: bad strings like `meta|option` break this
  return Toggle[v] and Toggle[v]():map(key) or Toggle.option(v):map(key)
end

local function ptogglelist(cmd)
  local success, err = pcall(cmd)
  if not success and err then
    vim.notify(err, vim.log.levels.ERROR)
  end
end

-- TODO: map `vim.diagnostic.setqflist`
M.togglelist = {
  {
    '<leader>xl',
    function()
      ptogglelist(vim.cmd[vim.fn.getloclist(0, { winid = 0 }).winid ~= 0 and 'lclose' or 'lopen'])
    end,
    desc = 'Location List',
  },
  {
    '<leader>xq',
    function()
      ptogglelist(vim.cmd[vim.fn.getqflist({ winid = 0 }).winid ~= 0 and 'cclose' or 'copen'])
    end,
    desc = 'Quickfix List',
  },
}

return M
