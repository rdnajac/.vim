-- vim:fdm=marker
local wk = require('which-key')

local function insert_comment(lhs, tag)
  local above = lhs:sub(2, 2) == lhs:sub(2, 2):upper()
  local dir = above and 'above' or 'below'
  local prefix = above and 'O' or 'o'
  local content = tag ~= '' and tag .. ': ' or ''
  local cmd = string.format('%s<Esc>Vc%s¿<Esc>:normal gcc<CR>A<BS>', prefix, content)
  local desc = ('Insert %s comment (%s)'):format(tag ~= '' and tag or 'plain', dir)
  return { lhs, cmd, desc = desc, silent = true }
end

require('which-key').add({
  { 'co', group = 'comment below' },
  { 'cO', group = 'comment above' },
  insert_comment('coo', ''),
  insert_comment('cOo', ''),
  insert_comment('cOO', ''),
  insert_comment('cot', 'TODO'),
  insert_comment('cOt', 'TODO'),
  insert_comment('cof', 'FIXME'),
  insert_comment('cOf', 'FIXME'),
  insert_comment('coh', 'HACK'),
  insert_comment('cOh', 'HACK'),
  insert_comment('cob', 'BUG'),
  insert_comment('cOb', 'BUG'),
  insert_comment('cop', 'PERF'),
  insert_comment('cOp', 'PERF'),
  insert_comment('cox', 'XXX'),
  insert_comment('cOx', 'XXX'),
})

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
  map_pickers('P', vim.g.lazypath, 'Plugins'),
  map_pickers('L', vim.g.lazypath .. '/LazyVim', 'LazyVim'),
  map_pickers('S', vim.g.lazypath .. '/snacks.nvim', 'Snacks'),
  map_pickers('v', vim.fn.expand('$VIMRUNTIME'), '$VIMRUNTIME'),
  map_pickers('V', vim.fn.expand('$VIM'), '$VIM'),
  { '<leader>fb', function() Snacks.picker.buffers() end, desc = 'Buffers', },
  { '<leader>fB', function() Snacks.picker.buffers({ hidden = true, nofile = true }) end, desc = 'Buffers (all)', },
  { '<leader>sb', function() Snacks.picker.lines() end, desc = 'Buffer Lines', },
  { '<leader>sB', function() Snacks.picker.grep_buffers() end, desc = 'Grep Open Buffers', },
  { '\\p', function() Snacks.picker.lazy() end, desc = 'Plugin Specs' },

  { '<leader>dp', group = 'profiler' },
  { '<leader>dps', function() Snacks.profiler.scratch() end, desc = 'Profiler Scratch Buffer' } ,
  { '<leader>dr', function() Snacks.profiler.scratch() end, mode = { 'n', 'v' }} ,
  { ',,', function() Snacks.terminal.toggle() end, mode = { 'n', 't' }} ,
})

Snacks.toggle.profiler():map('<leader>dpp')
Snacks.toggle.profiler_highlights():map('<leader>dph')

vim.keymap.set({ 'i', 'n', 's' }, '<esc>', function()
  vim.cmd('noh')
  -- LazyVim.cmp.actions.snippet_stop()
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

require('lazy.spec.snacks.toggle').translucency():map('<leader>ub', { desc = 'Toggle Translucent Background' })
require('lazy.spec.snacks.toggle').virtual_text():map('<leader>uv', { desc = 'Toggle Virtual Text' })
require('lazy.spec.snacks.toggle').color_column():map('<leader>u\\', { desc = 'Toggle Color Column' })
