local nv = _G.nv or require('nvim.util')
local M = {}

-- apply these keys later
M.after = function()
  Snacks.keymap.set('n', 'K', vim.lsp.buf.hover, { lsp = {}, desc = 'LSP Hover' })
  Snacks.keymap.set({ 'n', 'x' }, '<M-CR>', Snacks.debug.run, { ft = 'lua' })
  Snacks.util.on_key('<Esc>', function() vim.cmd.nohlsearch() end)
  M.map(M.togglelist)
end

M.specs = {
  {
    'folke/which-key.nvim',
    -- see icon rules at `$PACKDIR/opt/which-key.nvim/lua/which-key/icons.lua`
    config = function()
      local wk = require('which-key')
      wk.setup({
        keys = { scroll_down = '<C-j>', scroll_up = '<C-k>' },
        preset = 'helix',
        replace = {
          desc = {
            -- { '<Plug>%(?(.*)%)?', '%1' },
            { '^%+', '' },
            { '<[cC]md>', ':' },
            { '<[cC][rR]>', '󰌑 ' },
            { '<[sS]ilent>', '' },
            { '^lua%s+', '' },
            { '^lua%s+', '' },
            { '^call%s+', '' },
            -- { '^:%s*', '' },
          },
        },
        show_help = false,
        sort = { 'order', 'alphanum', 'case', 'mod' },
        spec = {
          {
            '<leader>?',
            function() wk.show({ global = false }) end,
            desc = 'Buffer Keymaps (which-key)',
          },
          {
            '<C-w><Space>',
            function() wk.show({ keys = '<C-w>', loop = true }) end,
            desc = 'Window Hydra Mode (which-key)',
          },
        },
      })
    end,
  },
  {
    'NStefan002/screenkey.nvim',
    enabled = false,
    opts = function() return require('nvim.keys.opts').screenkey() end,
    toggles = {
      ['<leader>uk'] = {
        name = 'Screenkey floating window',
        get = function() return require('screenkey').is_active() end,
        set = function() return require('screenkey').toggle() end,
      },
      ['<leader>uK'] = {
        name = 'Screenkey statusline component',
        get = function() return require('screenkey').statusline_component_is_active() end,
        set = function() return require('screenkey').toggle_statusline_component() end,
      },
    },
  },
  {
    'monaqa/dial.nvim',
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
  local Toggle = Snacks.Toggle
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
