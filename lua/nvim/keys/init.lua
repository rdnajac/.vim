Plug({
  require('nvim.keys.which'),
  -- require('nvim.keys.screen'),
})

local modes = { 'n', 'v', 'x', 'i', 't', 'o', 'c', 's' }
local function has_mode(t) return type(t[1]) == 'table' or vim.tbl_contains(modes, t[1]) end

-- TODO: if table has `ft` or `lsp` keys, use `Snacks.keymap.set()`
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

local M = {
  map = function(t) vim.iter(vim.islist(t) and t or { t }):map(normalize):each(vim.keymap.set) end,
  ---@param key string normal mode keys mapped by snacks.toggle.Class method
  ---@param v string|table the preset toggle name or the table of opts
  new_snacks_toggle = function(key, v)
    local Toggle = Snacks.toggle
    if type(v) == 'table' then
      return Toggle.new(v):map(key)
    end -- XXX: bad strings like `meta|option` break this
    return Toggle[v] and Toggle[v]():map(key) or Toggle.option(v):map(key)
  end,
}

M.register = function(spec)
  local keys, toggles = spec.keys, spec.toggles
  if keys then
    M.map(vim.is_callable(keys) and keys() or keys)
  end
  if toggles then
    for key, v in pairs(toggles) do
      M.new_snacks_toggle(key, v)
    end
  end
end


vim.schedule(function()
  local function edit_luamod(name)
    -- name = name:gsub('%.', '/')
    local file = vim.fs.joinpath(vim.fn.stdpath('config'), 'lua', name, 'init.lua')
    vim.fn['edit#'](vim.uv.fs_stat(file) and file or file:gsub('/init.lua$', '.lua'))
  end

  M.map({
    { 'glb', function() return edit_luamod('blink') end },
    { 'glm', function() return edit_luamod('munchies') end },
    { 'glM', function() return edit_luamod('nvim/mini') end },
    { 'glf', function() return edit_luamod('nvim/fs') end },
    { 'glk', function() return edit_luamod('nvim/keys') end },
    { 'gll', function() return edit_luamod('nvim/lsp') end },
    { 'glt', function() return edit_luamod('nvim/treesitter') end },
    { 'glu', function() return edit_luamod('nvim/ui') end },
    { 'glv', function() return edit_luamod('nvim/util') end },
  })

  M.map({
    -- FIXME: add xmap to increment selection
    { '<C-Space>', 'vin', { desc = 'Select Treesitter Node', remap = true } },
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
    {
      '<leader>U',
      function() require('undotree').open({ cmd = [[20vnew]] }) end,
      desc = 'Undotree',
    },
  })

  if Snacks then
    M.map({
      { { 'x' }, '/', Snacks.picker.grep_word },
      { { 'n' }, ',,', Snacks.picker.buffers },
      { { 'n' }, ',.', Snacks.scratch.open },
      { { 'i' }, '<C-x><C-i>', Snacks.picker.icons },
      { { 'n', 't' }, '<C-Bslash>', Snacks.terminal.toggle },
      { { 'n', 't' }, ']]', function() Snacks.words.jump(vim.v.count1) end },
      { { 'n', 't' }, '[[', function() Snacks.words.jump(-vim.v.count1) end },
      { 'dI', 'dai', { desc = 'Delete (Snacks) Indent', remap = true } },
      { 'vI', 'vai', { desc = 'Select (Snacks) Indent', remap = true } },
    })
    Snacks.keymap.set('n', 'K', vim.lsp.buf.hover, { lsp = {}, desc = 'LSP Hover' })
    Snacks.keymap.set({ 'n', 'x' }, '<M-CR>', Snacks.debug.run, { ft = 'lua' })

    Snacks.util.on_key('<Esc>', function() vim.cmd.nohlsearch() end)
    for key, v in pairs(require('nvim.keys.toggles')) do
      M.new_snacks_toggle(key, v)
    end
  end

  local descriptions = {
    ['['] = 'prev',
    [']'] = 'next',
    ['g'] = 'goto',
    ['z'] = 'fold',
    [vim.g.mapleader] = '<leader>',
    [vim.g.maplocalleader] = '<localleader>',
    ['co'] = 'comment',
    ['cO'] = 'comment above',
  }

  if package.loaded['which-key'] then
    for k, v in pairs(descriptions) do
      require('which-key').add({ k, desc = v, icon = { icon = '' } })
    end
  end
end)

return M
