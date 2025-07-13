-- vim:fdm=marker
-- TODO: move to snacks plugin spec
local wk = require('which-key')

-- stylua: ignore
wk.add({
  { mode = { 'n', 't' }, ',,', function() Snacks.terminal.toggle() end },
  -- { '\\p', function() Snacks.picker.lazy() end, desc = 'Plugin Specs' },
})

local function map_pickers(key, path, desc, extra_opts)
  local defaults = { cwd = path, matcher = { frecency = true }, title = desc }
  local opts = vim.tbl_extend('force', defaults, extra_opts or {})
  -- stylua: ignore
  return {
    { '<leader>f' .. key, function() Snacks.picker.files(opts) end, desc = desc },
    { '<leader>s' .. key, function() Snacks.picker.grep(opts) end, desc = desc },
  }
end

-- stylua: ignore
wk.add({
  -- frequently used pickerss
  map_pickers('c', vim.fn.stdpath('config'), 'Config Files'),
  map_pickers('.', os.getenv('HOME') .. '/.local/share/chezmoi', 'Dotfiles'),
  map_pickers('G', vim.fn.expand('~/GitHub/'), 'GitHub Repos'),
  map_pickers('p', vim.g.plug_home, 'Vim Plugins'),
  map_pickers('P', vim.fs.joinpath(vim.fn.stdpath('data'), 'site', 'pack', 'core', 'opt') , 'Nvim Plugins', {ft = 'lua'}),
  -- map_pickers('L', vim.g.lazypath .. '/LazyVim', 'LazyVim'),
  -- map_pickers('S', vim.g.lazypath .. '/snacks.nvim', 'Snacks'),
  map_pickers('v', vim.fn.expand('$VIMRUNTIME'), '$VIMRUNTIME'),
  map_pickers('V', vim.fn.expand('$VIM'), '$VIM'),
  -- buffers
  { '<leader>fb', function() Snacks.picker.buffers() end, desc = 'Buffers', },
  { '<leader>fB', function() Snacks.picker.buffers({ hidden = true, nofile = true }) end, desc = 'Buffers (all)', },
  { '<leader>sb', function() Snacks.picker.lines() end, desc = 'Buffer Lines', },
  { '<leader>sB', function() Snacks.picker.grep_buffers() end, desc = 'Grep Open Buffers', },
})

Snacks.toggle.profiler():map('<leader>dpp')
Snacks.toggle.profiler_highlights():map('<leader>dph')

vim.keymap.set({ 'i', 'n', 's' }, '<esc>', function()
  vim.cmd('noh')
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
-- stylua: ignore
Snacks.toggle .option('conceallevel', {
    off = 0,
    on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2,
    name = 'Conceal Level',
  }) :map('<leader>uc')

Snacks.toggle.diagnostics():map('<leader>ud')
Snacks.toggle.dim():map('<leader>uD')
Snacks.toggle.treesitter():map('<leader>ut')
Snacks.toggle.indent():map('<leader>ug')
Snacks.toggle.scroll():map('<leader>us')
Snacks.toggle.words():map('<leader>uw')
Snacks.toggle.zoom():map('<leader>uZ')

require('plugins.snacks.toggle').translucency():map('<leader>ub', { desc = 'Toggle Translucent Background' })
require('plugins.snacks.toggle').virtual_text():map('<leader>uv', { desc = 'Toggle Virtual Text' })
require('plugins.snacks.toggle').color_column():map('<leader>u\\', { desc = 'Toggle Color Column' })
