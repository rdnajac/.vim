-- vim:fdm=marker
local wk = require('which-key')

-- stylua: ignore start
vim.keymap.set({ 'n', 'v' }, '<leader>dr', function() Snacks.debug.run() end)
vim.keymap.set({ 'n', 't' }, ',,', function() Snacks.terminal.toggle() end)
-- stylua: ignore end

local p = vim.fn.stdpath('config') .. '/lua/'
local function config(lhs, mod)
  return { lhs, '<Cmd>edit ' .. p .. mod .. '.lua<CR>', desc = mod }
end

-- stylua: ignore
wk.add({
  config('\\a', 'nvim/autocmds'),
  config('\\i', 'nvim/init'),
  config('\\k', 'nvim/keymaps'),
  config('\\o', 'nvim/options'),
  config('\\l', 'lazy/spec/init'),
  config('\\b', 'lazy/bootstrap.lua'),
  { '\\p', function() Snacks.picker.lazy() end, desc = 'Plugin Specs' },
})

-- dual pickers {{{2
local function map_pickers(key, path, desc)
  local opts = { cwd = path, matcher = { frecency = true } }
-- stylua: ignore
  return {
    { '<leader>f' .. key, function() Snacks.picker.files(opts) end, desc = desc, },
    { '<leader>s' .. key, function() Snacks.picker.grep(opts) end, desc = desc, },
  }
end

-- stylua: ignore
wk.add({
  map_pickers('c', vim.fn.stdpath('config'), 'Config Files'),
  map_pickers('G', vim.fn.expand('~/GitHub/'), 'GitHub Repos'),
  map_pickers('P', lazypath, 'Plugins'),
  map_pickers('L', lazypath .. '/LazyVim', 'LazyVim'),
  map_pickers('S', lazypath .. '/snacks.nvim', 'Snacks'),
  map_pickers('v', vim.fn.expand('$VIMRUNTIME'), '$VIMRUNTIME'),
  map_pickers('V', vim.fn.expand('$VIM'), '$VIM'),
  { '<leader>fb', function() Snacks.picker.buffers() end, desc = 'Buffers', },
  { '<leader>fB', function() Snacks.picker.buffers({ hidden = true, nofile = true }) end, desc = 'Buffers (all)', },
  { '<leader>sb', function() Snacks.picker.lines() end, desc = 'Buffer Lines', },
  { '<leader>sB', function() Snacks.picker.grep_buffers() end, desc = 'Grep Open Buffers', },
})

wk.add({
  { '<leader>dp', group = 'profiler' },
  -- stylua: ignore
  { '<leader>dps', function() Snacks.profiler.scratch() end, desc = 'Profiler Scratch Buffer' } ,
})
Snacks.toggle.profiler():map('<leader>dpp')
Snacks.toggle.profiler_highlights():map('<leader>dph')

vim.keymap.set({ 'i', 'n', 's' }, '<esc>', function()
  vim.cmd('noh')
  LazyVim.cmp.actions.snippet_stop()
  return '<Esc>'
end, { expr = true, desc = 'Escape and Clear hlsearch' })

-- stylua: ignore
wk.add({
  { '<leader>u', group = 'ui', icon = { icon = '󰙵 ', color = 'cyan' } },
  { '<leader>uC', function() Snacks.picker.colorschemes() end, desc = 'Colorschemes', icon = { icon = ' ', color = 'yellow' }, },
  { '<leader>ui', function() vim.show_pos() end, desc = 'Inspect Pos', },
  { '<leader>uI', function() vim.treesitter.inspect_tree() vim.api.nvim_input('I') end, { desc = 'Inspect Tree' }, },
  { '<leader>un', function() Snacks.notifier.hide() end, desc = 'Dismiss Notifications', },
  { '<leader>uz', function() Snacks.zen() end, desc = 'Zen Mode', icon = { icon = ' ', color = 'blue' }, },
})

Snacks.toggle.animate():map('<leader>ua')
Snacks.toggle
  .option('conceallevel', {
    off = 0,
    on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2,
    name = 'Conceal Level',
  })
  :map('<leader>uc')
Snacks.toggle.diagnostics():map('<leader>ud')
Snacks.toggle.dim():map('<leader>uD')
Snacks.toggle.treesitter():map('<leader>ut')
Snacks.toggle.indent():map('<leader>ug')
Snacks.toggle.scroll():map('<leader>us')
Snacks.toggle.words():map('<leader>uw')
Snacks.toggle.zoom():map('<leader>uZ')

require('nvim.util.toggle').translucency():map('<leader>ub', { desc = 'Toggle Translucent Background' })
require('nvim.util.toggle').virtual_text():map('<leader>uv', { desc = 'Toggle Virtual Text' })
require('nvim.util.toggle').color_column():map('<leader>u\\', { desc = 'Toggle Color Column' })
