local M = {}

M.after = function()
  M.map({
    { '-', '<Cmd>Oil<CR>' },
    { '<leader>ui', '<Cmd>Inspect<CR>' },
    { '<leader>uI', '<Cmd>Inspect!<CR>' },
    { '<leader>uT', '<Cmd>lua vim.treesitter.inspect_tree(); vim.api.nvim_input("I")<CR>' },
    { '<C-Space>', 'vin', { desc = 'Select Treesitter Node', remap = true } },
    { 'dI', 'dai', { desc = 'Delete (Snacks) Indent', remap = true } },
    { 'vI', 'vai', { desc = 'Select (Snacks) Indent', remap = true } },
    { ']]', function() Snacks.words.jump(vim.v.count1) end, mode = { 'n', 't' } },
    { '[[', function() Snacks.words.jump(-vim.v.count1) end, mode = { 'n', 't' } },
  })
  M.map(require('nvim.keys.bookmarks'))
  M.map(M.togglelist)
  if not Snacks then
    return
  end
  Snacks.keymap.set('n', 'K', vim.lsp.buf.hover, { lsp = {}, desc = 'LSP Hover' })
  Snacks.keymap.set({ 'n', 'x' }, '<M-CR>', Snacks.debug.run, { ft = 'lua' })
  Snacks.util.on_key('<Esc>', function() vim.cmd.nohlsearch() end)
  for key, v in pairs(require('nvim.keys.toggles')) do
    M.new_snacks_toggle(key, v)
  end
end

M.specs = {
  -- require('nvim.keys.which'),
  -- require('nvim.keys.screen'),
  require('nvim.blink'),
  {
    'monaqa/dial.nvim',
    lazy = true, -- TODO: lazy load this plugin
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

M.map = function(t)
  if not t or not vim.islist(t) then
    return
  end
  vim.iter(t):map(_parse):each(vim.keymap.set)
end

---@param key string normal mode keys mapped by snacks.toggle.Class method
---@param v string|table the preset toggle name or the table of opts
M.new_snacks_toggle = function(key, v)
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

M.register = function(spec)
  if spec.keys then
    M.map(spec.keys)
  end
  if spec.toggles then
    for key, v in pairs(spec.toggles) do
      M.new_snacks_toggle(key, v)
    end
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
  {
    '<leader>xd',
    vim.diagnostic.setqflist,
    desc = 'Quickfix List',
  },
}

return M
