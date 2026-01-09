-- see icon rules at ~/.local/share/nvim/site/pack/core/opt/which-key.nvim/lua/which-key/icons.lua
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
  -- triggers = { { '<auto>', mode = 'nixsotc' } },
})

local spec = {
  {
    mode = { 'n', 'v' },
    -- TODO: add each bracket mapping manually
    { '[', group = 'prev' },
    { ']', group = 'next' },
    { 'g', group = 'goto' },
    { 'z', group = 'fold' },
  },
  { hidden = true, { 'g~' }, { 'g#' }, { 'g*' }, { 'gc' } },
}

local groups = {
  { 'co', group = 'comment below' },
  { 'cO', group = 'comment above' },
  { 'gr', group = 'LSP', icon = { icon = '' } },
  { '<leader>', group = '<leader>', icon = { icon = '' } },
  { '<leader>b', group = 'buffers' },
  { '<leader>c', group = 'code' },
  { '<leader>d', group = 'debug' },
  { '<leader>dp', group = 'profiler' },
  { '<leader>f', group = 'file/find' },
  { '<leader>g', group = 'git' },
  { '<leader>s', group = 'search' },
  { '<leader>u', group = 'ui' },
  { '<localleader>l', group = 'vimtex' },
  { '<localleader>r', group = 'R', icon = { icon = ' ', color = 'blue' } },
  { 'Z', group = 'Z' },
}

local descriptions = {
  cdc = [[stdpath('config')]],
  cdC = [[stdpath('cache')]],
  cdd = [[stdpath('data')]],
  cds = [[stdpath('state')]],
  gx = 'Open with system app',
  ZQ = ':q!',
  ZZ = ':x',
}

spec[#spec + 1] = {}

for key, desc in pairs(descriptions) do
  table.insert(spec, { key, desc = desc })
  -- groups[#groups + 1] = { key, desc = desc }
end

vim.list_extend(spec, groups)

-- from lazyvim
local objects = {
  { ' ', desc = 'whitespace' },
  { '"', desc = '" string' },
  { "'", desc = "' string" },
  { '(', desc = '() block' },
  { ')', desc = '() block with ws' },
  { '<', desc = '<> block' },
  { '>', desc = '<> block with ws' },
  { '?', desc = 'user prompt' },
  { '[', desc = '[] block' },
  { ']', desc = '[] block with ws' },
  { '_', desc = 'underscore' },
  { '`', desc = '` string' },
  { 'a', desc = 'argument' },
  { 'b', desc = ')]} block' },
  { 'c', desc = 'class' },
  { 'd', desc = 'digit(s)' },
  { 'e', desc = 'CamelCase / snake_case' },
  { 'f', desc = 'function' },
  { 'g', desc = 'entire file' },
  { 'i', desc = 'indent' },
  { 'o', desc = 'block, conditional, loop' },
  { 'q', desc = 'quote `"\'' },
  { 't', desc = 'tag' },
  { 'u', desc = 'use/call' },
  { 'U', desc = 'use/call without dot' },
  { '{', desc = '{} block' },
  { '}', desc = '{} with ws' },
}

---@type table<string, string>
local mappings = {
  around = 'a',
  inside = 'i',
  around_next = 'an',
  inside_next = 'in',
  around_last = 'al',
  inside_last = 'il',
}
-- mappings.goto_left = nil
-- mappings.goto_right = nil

---@type wk.Spec[]
local ret = { mode = { 'o', 'x' } }

-- TODO: merge with mini ai spec and add descriptions for those mappings too
vim.iter(mappings):each(function(name, prefix)
  name = name:match('^%a+_(.+)') or name
  ret[#ret + 1] = { prefix, group = name }
  vim.iter(objects):each(function(obj)
    local desc = obj.desc
    if prefix:sub(1, 1) == 'i' then
      desc = desc:gsub(' with ws', '')
    end
    ret[#ret + 1] = { prefix .. obj[1], desc = obj.desc }
  end)
end)

spec = vim.list_extend(spec, ret)

vim.schedule(function()
  -- override: only show select registers
  ---@diagnostic disable: inject-field
  require('which-key.plugins.registers').registers = [[*+"-:.%/#=_01234567890qZ]]

  wk.add(spec)
  wk.add(require('folke.snacks.keys'))

  -- TODO: move me!
  local function coerce(char)
    return function()
      vim.api.nvim_feedkeys(vim.keycode('<Plug>(abolish-coerce-word)') .. char, 'nt', false)
    end
  end

  wk.add({
    { 'cR', group = 'CoeRce', icon = { icon = '󰬴' } },
    { 'cRc', coerce('c'), desc = 'coerceCamelCase' },
    { 'cRm', coerce('m'), desc = 'coerceMixedCase' },
    { 'cRp', coerce('p'), desc = 'coerceMixedcase' },
    { 'cRs', coerce('s'), desc = 'coerce_snake_case' },
    { 'cR_', coerce('_'), desc = 'coercesnakecase' },
    { 'cRu', coerce('u'), desc = 'COERCE_UPPER_CASE' },
    { 'cRU', coerce('U'), desc = 'COERCE_UPPER_CASE' },
    { 'cR-', coerce('-'), desc = 'coerce-dash-case' },
    { 'cRk', coerce('k'), desc = 'coerce-dash-case' },
    { 'cR.', coerce('.'), desc = 'coerce.dot.case' },
    { 'cR<Space>', coerce(' '), desc = 'coerce space case' },
  })
end)
