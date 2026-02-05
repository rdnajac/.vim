-- apply these keys later
vim.schedule(function()
  Snacks.keymap.set('n', 'K', vim.lsp.buf.hover, { lsp = {}, desc = 'LSP Hover' })
  Snacks.keymap.set({ 'n', 'x' }, '<M-CR>', Snacks.debug.run, { ft = 'lua' })
  Snacks.util.on_key('<Esc>', function() vim.cmd.nohlsearch() end)
end)

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

local M = {}

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
          '<leader>?',
          function() wk.show({ global = false }) end,
          desc = 'Buffer Keymaps (which-key)',
        },
        {
          '<C-w><Space>',
          function() wk.show({ keys = '<C-w>', loop = true }) end,
          desc = 'Window Hydra Mode (which-key)',
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
}

M.map = function(t) vim.iter(t):map(_parse):each(vim.keymap.set) end
M.map_snacks_toggle = function(key, v)
  if type(v) == 'table' then
    Snacks.toggle.new(v):map(key)
  end
  if type(v) == 'string' then
    if Snacks.toggle[v] ~= nil then
      Snacks.toggle[v]():map(key)
    else
      Snacks.toggle.option(v):map(key)
    end
  end
  -- elseif type(v) == 'function' then v():map(key) end
end

return M
