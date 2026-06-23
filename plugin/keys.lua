--- `$PACKDIR/opt/which-key.nvim/lua/which-key/icons.lua`

local function without_desc(mod)
  local expand = mod.expand
  mod.expand = function(...)
    local items = expand(...)
    for _, item in ipairs(items) do
      item.desc = ''
    end
    return items
  end
  return mod
end

local registers = [[*+"-:.%/#=_0123456789]]
package.preload['which-key.plugins.registers'] = function()
  local mod = dofile(vim.api.nvim_get_runtime_file('lua/which-key/plugins/registers.lua', true)[1])
  mod.registers = registers
  return without_desc(mod)
end

package.preload['which-key.plugins.marks'] = function()
  local mod = dofile(vim.api.nvim_get_runtime_file('lua/which-key/plugins/marks.lua', true)[1])
  local original_expand = mod.expand
  mod.expand = function()
    return vim.tbl_filter(function(c)
      return c.key:match('%u')
    end, original_expand())
  end
  return without_desc(mod)
end

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
    --   { '<leader>b', group = 'buffers' },
    --   { '<leader>c', group = 'code' },
    --   { '<leader>d', group = 'debug' },
    --   { '<leader>dp', group = 'profiler' },
    --   { '<leader>f', group = 'file/find' },
    --   { '<leader>g', group = 'git' },
    --   { '<leader>s', group = 'search' },
    --   { '<leader>u', group = 'ui' },
    --   { '<localleader>l', group = 'vimtex' },
    --   { '<localleader>r', group = 'R', icon = { icon = ' ', color = 'blue' } },
    {
      '<leader>?',
      function()
        wk.show({ global = false })
      end,
      desc = 'which-key?',
    },
    {
      '<C-w><Space>',
      function()
        wk.show({ keys = '<C-w>', loop = true })
      end,
    },
    { 'gr', group = 'LSP', icon = { icon = '' } },
    { 'gl', group = 'LSP', icon = { icon = '🍬' } },
    { hidden = true, { 'g~' }, { 'gc' } },
  },
})

vim.schedule(function()
  for k, v in pairs(require('nvim.keys.descriptions')) do
    wk.add({ k, desc = v, icon = { icon = '' } })
  end

  -- treesitter
  -- incremental-selection (C-Space to init/expand, C-BS to shrink)
  vim.cmd([[nmap <C-Space> van | xmap <C-Space> an | xmap <C-BS> in]])
  -- TODO:
  -- Plug(nv.treesitter.textobjects)

  -- stylua: ignore
  vim.iter(nv.keys.toggles):each(function(k, v)
    if type(v) == 'table' then Snacks.toggle.new(v):map(k) end
    if type(v) == 'string' then Snacks.toggle.option(v):map(k) end
    if type(v) == 'function' then v():map(k) end
  end)
end)

return {}
