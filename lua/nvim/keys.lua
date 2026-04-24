vim.cmd([[
nnoremap ZB <Cmd>lua Snacks.bufdelete()<CR>
nnoremap Zb <Cmd>lua Snacks.bufdelete.other()<CR>
nnoremap ,. <Cmd>lua Snacks.scratch.open()<CR>
nnoremap ,, <Cmd>lua Snacks.picker.buffers()<CR>
nnoremap ,/ <Cmd>lua Snacks.picker.grep()<CR>
xnoremap /  <Cmd>lua Snacks.picker.grep_word()<CR>
inoremap <C-x><C-i> <Cmd>lua Snacks.picker.icons({ layout = require('munchies').insert })<CR>
inoremap <C-x><C-z> <Cmd>lua Snacks.picker.registers({ layout = require('munchies').insert })<CR>
]])

vim.schedule(function()
  Snacks.util.on_key('<Esc>', function() vim.cmd.nohlsearch() end)
  Snacks.keymap.set({ 'n' }, 'K', vim.lsp.buf.hover, { lsp = {} })
  Snacks.keymap.set({ 'n', 'x' }, '<M-CR>', Snacks.debug.run, { ft = 'lua' })
  Snacks.keymap.set({ 'x' }, '<M-CR>', Snacks.debug.run, { ft = 'markdown' })
  -- normal and terminal mode keymaps
  for lhs, rhs in pairs({
    ['<C-Bslash>'] = function() Snacks.terminal.focus() end,
    [']]'] = function() Snacks.words.jump(vim.v.count1) end,
    ['[['] = function() Snacks.words.jump(-vim.v.count1) end,
  }) do
    vim.keymap.set({ 'n', 't' }, lhs, rhs)
  end
  -- stylua: ignore
  vim.iter(require('nvim.keys.toggles')):each(function(k, v)
    if type(v) == 'table' then Snacks.toggle.new(v):map(k) end
    if type(v) == 'string' then Snacks.toggle.option(v):map(k) end
    if type(v) == 'function' then v():map(k) end
  end)
end)

-- local registers = [[*+"-:.%/#=_0123456789]]
-- package.preload['which-key.plugins.registers'] = function()
--   local mod =
--     dofile(vim.g['plug#home'] .. '/which-key.nvim/lua/which-key/plugins/registers.lua')
--   mod.registers = registers
--   return mod
-- end
-- vim.schedule(function() require('which-key.plugins.registers').registers = registers end)
Plug({
  'folke/which-key.nvim',
  -- see icon rules at `$PACKDIR/opt/which-key.nvim/lua/which-key/icons.lua`
  init = function()
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
        { '<leader>?', function() wk.show({ global = false }) end, desc = 'which-key?' },
        { '<C-w><Space>', function() wk.show({ keys = '<C-w>', loop = true }) end },
        { 'gr', group = 'LSP', icon = { icon = '' } },
        { 'gl', group = 'LSP', icon = { icon = '🍬' } },
        { hidden = true, { 'g~' }, { 'gc' } },
      },
    })
    for k, v in pairs(require('nvim.keys.descriptions')) do
      wk.add({ k, desc = v, icon = { icon = '' } })
    end
  end,
})

return {}
