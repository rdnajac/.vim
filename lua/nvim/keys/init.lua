Plug({
  require('blink'),
  require('nvim.keys.which'),
  -- require('nvim.keys.screen'),
})

local modes = { 'n', 'v', 'x', 'i', 't', 'o', 'c', 's' }
local function has_mode(t) return type(t[1]) == 'table' or vim.tbl_contains(modes, t[1]) end

--- Converts a variety of table formats into `vim.keymap.set` opts
---@param t table
---@return string|table mode, string lhs,string|fun() rhs, table opts
local function normalize(t)
  -- stylua: ignore
  ---@diagnostic disable-next-line: redundant-return-value
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

local M = {}

M.map = function(t) vim.iter(vim.islist(t) and t or { t }):map(normalize):each(vim.keymap.set) end

local keys = {
  { 'glb', [[<Cmd>call edit#luamod('blink')<CR>]] },
  { 'glm', [[<Cmd>call edit#luamod('munchies')<CR>]] },
  { 'glf', [[<Cmd>call edit#luamod('nvim/fs')<CR>]] },
  { 'glk', [[<Cmd>call edit#luamod('nvim/keys')<CR>]] },
  { 'gll', [[<Cmd>call edit#luamod('nvim/lsp')<CR>]] },
  { 'glt', [[<Cmd>call edit#luamod('nvim/treesitter')<CR>]] },
  { 'glu', [[<Cmd>call edit#luamod('nvim/ui')<CR>]] },
  { 'glv', [[<Cmd>call edit#luamod('nvim/util')<CR>]] },
  { 'yu', function() require('nvim.util.debug').print() end, desc = 'Print Value' },
  { '<leader>ui', '<Cmd>Inspect<CR>' },
  { '<leader>uI', '<Cmd>Inspect!<CR>' },
  { '<leader>uT', '<Cmd>lua vim.treesitter.inspect_tree(); vim.api.nvim_input("I")<CR>' },
  { '<C-Space>', 'vin', { desc = 'Select Treesitter Node', remap = true } },
  { 'dI', 'dai', { desc = 'Delete (Snacks) Indent', remap = true } },
  { 'vI', 'vai', { desc = 'Select (Snacks) Indent', remap = true } },
  { ']]', function() Snacks.words.jump(vim.v.count1) end, mode = { 'n', 't' } },
  { '[[', function() Snacks.words.jump(-vim.v.count1) end, mode = { 'n', 't' } },
  {
    '<leader>xl',
    function() vim.cmd[vim.fn.getloclist(0, { winid = 0 }).winid ~= 0 and 'lclose' or 'lopen']() end,
    desc = 'Location List',
  },
  {
    '<leader>xq',
    function() vim.cmd[vim.fn.getqflist({ winid = 0 }).winid ~= 0 and 'cclose' or 'copen']() end,
    desc = 'Quickfix List',
  },
  { '<leader>xd', vim.diagnostic.setqflist, desc = 'Quickfix List' },
  { '<leader>U', function() require('undotree').open({ cmd = [[20vnew]] }) end, desc = 'Undotree' },
}

vim.schedule(function()
  M.map(keys)
  -- override the default config loading to improve performance
  package.preload['dial.config'] = function() return require('nvim.keys.dial') end
  -- load after startup
  Plug({
    {
      'monaqa/dial.nvim',
      keys = {
        { { 'n', 'x' }, '<C-a>', '<Plug>(dial-increment)' },
        { { 'n', 'x' }, 'g<C-a>', '<Plug>(dial-g-increment)' },
        { { 'n', 'x' }, '<C-x>', '<Plug>(dial-decrement)' },
        { { 'n', 'x' }, 'g<C-x>', '<Plug>(dial-g-decrement)' },
      },
    },
  })
  if Snacks then
    Snacks.keymap.set('n', 'K', vim.lsp.buf.hover, { lsp = {}, desc = 'LSP Hover' })
    Snacks.keymap.set({ 'n', 'x' }, '<M-CR>', Snacks.debug.run, { ft = 'lua' })
    Snacks.keymap.set({ 'n' }, 'ym', function() nv.yankmod() end, { ft = 'lua' })
    Snacks.util.on_key('<Esc>', function() vim.cmd.nohlsearch() end)
    for key, v in pairs(require('nvim.keys.toggles')) do
      M.new_snacks_toggle(key, v)
    end
  end
end)

---@param key string normal mode keys mapped by snacks.toggle.Class method
---@param v string|table the preset toggle name or the table of opts
M.new_snacks_toggle = function(key, v)
  local Toggle = Snacks.toggle
  if type(v) == 'table' then
    return Toggle.new(v):map(key)
  end -- XXX: bad strings like `meta|option` break this
  return Toggle[v] and Toggle[v]():map(key) or Toggle.option(v):map(key)
end

M.register = function(spec)
  local keys, toggles = spec.keys, spec.toggles
  if keys then
    keys = vim.is_callable(keys) and keys() or keys
    M.map(keys)
  end
  if toggles then
    for key, v in pairs(toggles) do
      M.new_snacks_toggle(key, v)
    end
  end
end

return M
