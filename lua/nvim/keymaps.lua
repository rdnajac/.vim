-- vim: fdm=marker fdl=1
local wk = require('which-key')

-- debug/health {{{2
local function command(lhs, cmd, opts)
  opts = opts or {}
  opts.desc = opts.desc or cmd
  return { lhs, '<Cmd>' .. cmd .. '<CR>', opts }
end

wk.add({
  { '<leader>d', group = 'debug' },
  command('<leader>da', 'ALEInfo'),
  command('<leader>db', 'BLINKC:p status'),
  { '<leader>dc', ':=vim.lsp.get_clients()[1].server_capabilities<CR>', desc = 'LSP Capabilities' },
  command('<leader>dd', 'LazyDev debug'),
  command('<leader>dl', 'LazyDev lsp'),
  command('<leader>dL', 'checkhealth vim.lsp'),
  command('<leader>dh', 'LazyHealth'),
  { '<leader>dS', ':=require("snacks").meta.get()<CR>', desc = 'Snacks' },
  { '<leader>dw', ':=vim.lsp.buf.list_workspace_folders()<CR>', desc = 'LSP Workspace Folders' },
})

vim.keymap.set({ 'n', 'v' }, '<leader>dr', function()
  Snacks.debug.run()
end)

-- edit config files  {{{2
local confpath = vim.fn.stdpath('config') .. '/lua/nvim/'
local function config(lhs, mod)
  return { lhs, '<Cmd>edit ' .. confpath .. mod .. '.lua<CR>', desc = mod }
end

-- stylua: ignore
wk.add({
  config('\\i', 'init'),
  config('\\a', 'autocmds'),
  config('\\o', 'options/init'),
  config('\\k', 'keymaps'),
  -- config('\\s', 'lazy/spec/init'),
  { '\\p', function() Snacks.picker.lazy() end, desc = 'Plugin Specs' },
  { '\\m', '<Cmd>edit ' .. vim.fn.stdpath('config') .. '/lua/munchies/init.lua<CR>', desc = 'Munchies' },
  { '\\u', '<Cmd>edit ' .. vim.fn.stdpath('config') .. '/lua/util/init.lua<CR>', desc = 'Utils' },
})

-- insert comments {{{2
local function insert_comment(lhs, text)
  local above = lhs:sub(-1) == lhs:sub(-1):upper()
  local dir = above and 'above' or 'below'
  local prefix = above and 'O' or 'o'
  local cmd = string.format('%s<Esc>Vc%s¿<Esc>:normal gcc<CR>A<BS>', prefix, text and text .. ': ' or '')
  local description = ('Insert %s (%s)'):format(text ~= '' and text or 'comment', dir)

  return { lhs, cmd, desc = description, silent = true }
end

vim.keymap.del('n', 'gc')
wk.add({
  { 'gc', group = 'comments' },
  insert_comment('gco', ''),
  insert_comment('gcO', ''),
  insert_comment('gct', 'TODO'),
  insert_comment('gcT', 'TODO'),
  insert_comment('gcf', 'FIXME'),
  insert_comment('gcF', 'FIXME'),
  insert_comment('gch', 'HACK'),
  insert_comment('gcH', 'HACK'),
  insert_comment('gcb', 'BUG'),
  insert_comment('gcB', 'BUG'),
})

-- cd {{{2
wk.add({
  { 'cd', group = 'cd', icon = { icon = '󰒋 ', color = 'blue' } },
  { 'cD', '<Cmd>SmartCD<CR>', desc = 'SmartCD' },
  { 'cdd', '<Cmd>SmartCD<CR>', desc = 'SmartCD' },
  { 'cdb', '<Cmd>cd %:p:h<BAR>pwd<CR>', desc = 'buffer directory' },
  { 'cdp', '<Cmd>cd %:p:h:h<BAR>pwd<CR>', desc = 'parent directory' },
})

-- nvim {{{1
-- stylua: ignore
wk.add({
icon = { icon = ' ', color = 'green' },
  command('cz',  'Chezmoi'),
  command('<leader>S',  'Scripts'),
  command('<leader>r',  'Restart'),
  command('<leader>R',  'restart!'),
  command('<leader>cd', 'CD'),
  command('<leader>q',  'Quit'),
  command('<leader>Q',  'Quit!'),
  command('<leader>z',  'Zoxide'),
    -- icon = { icon = '󰄻 ' },
  { '<leader>D', function() require('util.debugprint').insert() end, desc = 'Insert Debug Print' },
})

-- snacks {{{1
-- stylua: ignore
local function fu(lhs, fn, desc, mode)
  return { lhs, function() fn() end, desc = desc, mode = mode, }
end

wk.add({
  { '<leader>a', icon = { icon = ' ', color = 'azure' }, desc = 'Select All' },

  fu(',,', Snacks.terminal.toggle, 'Snacks Terminal', { 'n', 't' }),
  fu('<leader>.', Snacks.scratch, 'Toggle Scratch Buffer'),
  fu('<leader>>', Snacks.scratch.select, 'Select Scratch Buffer'),
  fu('<leader>,', Snacks.picker.buffers, 'Buffers'),
  fu('<leader>/', Snacks.picker.grep, 'Grep (Root Dir)'),
  fu('<leader>F', Snacks.picker.smart, 'Smart Find Files'),

  fu('<leader>bd', Snacks.bufdelete, 'Delete Buffer'),
  fu('<leader>h', Snacks.picker.help, 'Help'),

  { '<leader>f', group = 'file/find' },
  fu('<leader>fC', Snacks.rename.rename_file, 'Change (rename) file on disk'),
  fu('<leader>ff', Snacks.picker.files, 'Find Files'),
  fu('<leader>fr', Snacks.picker.recent, 'Find Recent'),

  { '<leader>g', group = 'git' },
  fu('<leader>gb', Snacks.picker.git_log_line, 'Git Blame Line'),
  fu('<leader>gB', Snacks.gitbrowse, 'Git Browse (open)'),
  fu('<leader>gd', Snacks.picker.git_diff, 'Git Diff (hunks)'),
  fu('<leader>gs', Snacks.picker.git_status, 'Git Status'),
  fu('<leader>gS', Snacks.picker.git_stash, 'Git Stash'),
  { '<leader>ga', ':!git add %<CR>', desc = 'Git Add (file)', mode = 'n' },
  fu('<leader>gg', Snacks.lazygit, 'Lazygit (cwd)', 'n'),
  fu('<leader>gf', Snacks.picker.git_log_file, 'Git Current File History', 'n'),
  fu('<leader>gl', Snacks.picker.git_log, 'Git Log (cwd)', 'n'),

  { '<leader>l', '<Cmd>Lazy<CR>', desc = 'Lazy' },
  fu('<leader>n', Snacks.picker.notifications, 'Notification History'),

  { '<leader>p', group = 'Pickers', icon = { icon = ' ' } },
  fu('<leader>P', Snacks.picker, 'Pickers'),
  fu('<leader>p"', Snacks.picker.registers, 'Registers'),
  fu('<leader>p/', Snacks.picker.search_history, 'Search History'),
  fu('<leader>pD', Snacks.picker.diagnostics_buffer, 'Buffer Diagnostics'),
  fu('<leader>pa', Snacks.picker.autocmds, 'Autocmds'),
  fu('<leader>pc', Snacks.picker.commands, 'Commands'),
  fu('<leader>p:', Snacks.picker.command_history, 'Command History'),
  fu('<leader>pd', Snacks.picker.diagnostics, 'Diagnostics'),
  fu('<leader>ph', Snacks.picker.highlights, 'Highlights'),
  fu('<leader>pi', Snacks.picker.icons, 'Icons'),
  fu('<leader>pj', Snacks.picker.jumps, 'Jumps'),
  fu('<leader>pk', Snacks.picker.keymaps, 'Keymaps'),
  fu('<leader>pp', Snacks.picker.resume, 'Resume'),
  fu('<leader>pq', Snacks.picker.qflist, 'Quickfix List'),

  { '<leader>s', group = 'search/grep' },
  fu('<leader>sa', Snacks.picker.autocmds, 'Autocmds'),
  fu('<leader>sC', Snacks.picker.commands, 'Commands'),
  fu('<leader>sh', Snacks.picker.help, 'Help Pages'),
  fu('<leader>sH', Snacks.picker.highlights, 'Highlights'),
  fu('<leader>si', Snacks.picker.icons, 'Icons'),
  fu('<leader>sk', Snacks.picker.keymaps, 'Keymaps'),
  fu('<leader>su', Snacks.picker.undo, 'Undotree'),
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
  { '<leader>fp', function() require('munchies.picker.plugins').files() end, desc = 'Lazy Plugins', },
  { '<leader>sp', function() require('munchies.picker.plugins').grep() end, desc = 'Lazy Plugins', },
})

-- snacks profiler {{{2
wk.add({
  { '<leader>dp', group = 'profiler' },
  -- stylua: ignore
  { '<leader>dps', function() Snacks.profiler.scratch() end, desc = 'Profiler Scratch Buffer' } ,
})
Snacks.toggle.profiler():map('<leader>dpp')
Snacks.toggle.profiler_highlights():map('<leader>dph')
-- }}}1

-- ui {{{2
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
  { '<leader>ur', '<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>', desc = 'Redraw/Clear/Diff' },
  { '<leader>uz', function() Snacks.zen() end, desc = 'Zen Mode', icon = { icon = ' ', color = 'blue' }, },
})

-- snacks toggles {{{3
Snacks.toggle.animate():map('<leader>ua')
-- Snacks.toggle.option('showtabline', {
--   off = 0,
--   on = vim.o.showtabline > 0 and vim.o.showtabline or 2,
--   name = 'Tabline',
-- }):map('<leader>uA')
-- stylua: ignore
Snacks.toggle.option('conceallevel', {
  off = 0,
  on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2,
  name = 'Conceal Level',
}):map('<leader>uc')
Snacks.toggle.diagnostics():map('<leader>ud')
Snacks.toggle.dim():map('<leader>uD')
Snacks.toggle.treesitter():map('<leader>ut')
Snacks.toggle.indent():map('<leader>ug')
Snacks.toggle.scroll():map('<leader>us')
Snacks.toggle.words():map('<leader>uw')
Snacks.toggle.zoom():map('<leader>uZ')

-- Custom toggles
require('munchies.toggle').translucency():map('<leader>ub', { desc = 'Toggle Translucent Background' })
require('munchies.toggle').virtual_text():map('<leader>uv', { desc = 'Toggle Virtual Text' })
require('munchies.toggle').color_column():map('<leader>u\\', { desc = 'Toggle Color Column' })
