-- vim: fdm=marker fdl=1
local wk = require('which-key')
-- better escape {{{2
local map_combo = require('mini.keymap').map_combo

for _, combo in ipairs({ 'jk', 'kj' }) do
  -- Map both 'jk' and 'kj' to <Esc> in normal-ish modes
  map_combo({ 'i', 'c', 'v', 's' }, combo, '<BS><BS><Esc>')
  -- Terminal mode: 'jk' and 'kj' to <C-\><C-n>
  map_combo('t', combo, '<BS><BS><C-\\><C-n>')
end

-- debug/health {{{2
local function command(lhs, cmd, opts)
  opts = opts or {}
  opts.desc = opts.desc or cmd
  return { lhs, '<Cmd>' .. cmd .. '<CR>', opts }
end

wk.add({
  { '<leader>d', group = 'debug' },
  command('<leader>da', 'ALEInfo'),
  command('<leader>db', 'BlinkCmp status'),
  { '<leader>dc', ':=vim.lsp.get_clients()[1].server_capabilities<CR>', desc = 'LSP Capabilities' },
  command('<leader>dd', 'LazyDev debug'),
  command('<leader>dl', 'LazyDev lsp'),
  command('<leader>dL', 'checkhealth vim.lsp'),
  command('<leader>dH', 'LazyHealth'),
  { '<leader>dS', ':=require("snacks").meta.get()<CR>', desc = 'Snacks' },
  { '<leader>dw', ':=vim.lsp.buf.list_workspace_folders()<CR>', desc = 'LSP Workspace Folders' },
})

local function health(lhs, module, opts)
  return command(lhs, 'checkhealth ' .. module, opts)
end

wk.add({
  { '<leader>dh', group = 'health', icon = { icon = '', color = 'red' } },
  health('<leader>dhc', 'config'),
  health('<leader>dhk', 'which-key'),
  health('<leader>dhs', 'snacks'),
})

vim.keymap.set({ 'n', 'v' }, '<leader>dr', function()
  Snacks.debug.run()
end)

-- edit config files  {{{2
local confpath = vim.fn.stdpath('config') .. '/lua/nvim/'
local function map_config(lhs, mod)
  return { lhs, '<Cmd>edit ' .. confpath .. mod .. '.lua<CR>', desc = mod }
end

-- stylua: ignore
wk.add({
  map_config('\\i', 'init'),
  map_config('\\a', 'autocmds'),
  map_config('\\o', 'options/init'),
  map_config('\\k', 'keymaps'),
  -- map_config('\\s', 'lazy/spec/init'),
  { '\\p', function() Snacks.picker.lazy() end, desc = 'Plugin Specs' },
  { '\\m', '<Cmd>edit ' .. vim.fn.stdpath('config') .. '/lua/munchies/init.lua<CR>', desc = 'Munchies' },
  { '\\u', '<Cmd>edit ' .. vim.fn.stdpath('config') .. '/lua/utils/init.lua<CR>', desc = 'Utils' },
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

-- vimrc/lazy/snacks {{{1
-- stylua: ignore
wk.add({
  { 'gL', function() require('util.togo').lazy() end, desc = 'Goto LazyVim module' },
  { 'gx', function() require('util.togo').gx() end, desc = 'Open with system app' },

  { '\\\\', function() Snacks.dashboard.open() end, desc = 'Snacks Dashboard', },
  { ',,', function() Snacks.terminal.toggle() end, desc = 'Snacks Terminal', mode = { 'n', 't' } },
  { '<leader>.', function() Snacks.scratch() end, desc = 'Toggle Scratch Buffer', },
  { '<leader>>', function() Snacks.scratch.select() end, desc = 'Select Scratch Buffer', },
  { '<leader>,', function() Snacks.picker.buffers() end, desc = 'Buffers', },
  { '<leader>/', function() Snacks.picker.grep() end, desc = 'Grep (Root Dir)', icon = { icon = ' ' }, },

  { '<leader>D', function() require('util.debugprint').insert() end, desc = 'Insert Debug Print' },
  { '<leader>F', function() Snacks.picker.smart() end, desc = 'Smart Find Files', },
  { '<leader>S', '<Cmd>Scripts<CR>', desc = 'Scriptnames', icon = { icon = '' } },
  { '<leader>r', '<Cmd>Restart<CR>', desc = 'Restart Neovim', icon = { icon = '' } },
  { '<leader>R', '<Cmd>restart!<CR>', desc = 'Force restart Neovim', icon = { icon = '' } },
  -- { '<leader>r', function() require('util.restart') end, desc = 'Restart Neovim', icon = { icon = '' } },

  { '<leader>a', icon = { icon = ' ', color = 'azure' }, desc = 'Select All' },

  { '<leader>bd', function() Snacks.bufdelete() end, desc = 'Delete Buffer', mode = 'n' },

  { '<leader>c', group = 'code' },
  { '<leader>cz', function() require('munchies.picker').chezmoi() end, desc = 'Chezmoi', },

  { '<leader>h', function() Snacks.picker.help() end, desc = 'Help', },

  { '<leader>f', group = 'file/find', icon = { color = 'azure' } },
  { '<leader>fC', function() Snacks.rename.rename_file() end, desc = 'Change (rename) File on disk', },
  { '<leader>ff', function() Snacks.picker.files({ cwd = Snacks.git.get_root() }) end, desc = 'Files (root)', },
  { '<leader>fr', function() Snacks.picker.recent() end, desc = 'Recent' },
  { '<leader>fR', function() Snacks.picker.recent({ filter = { cwd = true } }) end, desc = 'Recent (cwd)', },

  { '<leader>g', group = 'git' },
  { '<leader>gb', function() Snacks.picker.git_log_line() end, desc = 'Git Blame Line', },
  { '<leader>gB', function() Snacks.gitbrowse() end, desc = 'Git Browse (open)', },
  { '<leader>gd', function() Snacks.picker.git_diff() end, desc = 'Git Diff (hunks)', },
  { '<leader>gs', function() Snacks.picker.git_status() end, desc = 'Git Status', },
  { '<leader>gS', function() Snacks.picker.git_stash() end, desc = 'Git Stash', },
  { '<leader>ga', ':!git add %<CR>', desc = 'Git Add (file)', mode = 'n' },
  { '<leader>gg', function() Snacks.lazygit() end, desc = 'Lazygit (cwd)', mode = 'n' },
  { '<leader>gf', function() Snacks.picker.git_log_file() end, desc = 'Git Current File History', mode = 'n' },
  { '<leader>gl', function() Snacks.picker.git_log() end, desc = 'Git Log (cwd)', mode = 'n' },

  { '<leader>l', '<Cmd>Lazy<CR>', desc = 'Lazy' },

  { '<leader>n', function() Snacks.picker.notifications() end, desc = "Notification History" },

  { '<leader>p', group = 'Pickers', icon = { icon = ' ' } },
  { '<leader>P', function() Snacks.picker() end, desc = 'Pickers' },
  { '<leader>p"', function() Snacks.picker.registers() end, desc = 'Registers', },
  { '<leader>p/', function() Snacks.picker.search_history() end, desc = 'Search History', },
  { '<leader>pD', function() Snacks.picker.diagnostics_buffer() end, desc = 'Buffer Diagnostics', },
  { '<leader>pa', function() Snacks.picker.autocmds() end, desc = 'Autocmds', },
  { '<leader>pc', function() Snacks.picker.commands() end, desc = 'Commands', },
  { '<leader>p:', function() Snacks.picker.command_history() end, desc = 'Command History', },
  { '<leader>pd', function() Snacks.picker.diagnostics() end, desc = 'Diagnostics', },
  { '<leader>ph', function() Snacks.picker.highlights() end, desc = 'Highlights', },
  { '<leader>pi', function() Snacks.picker.icons() end, desc = 'Icons', },
  { '<leader>pj', function() Snacks.picker.jumps() end, desc = 'Jumps', },
  { '<leader>pk', function() Snacks.picker.keymaps() end, desc = 'Keymaps', },
  { '<leader>pp', function() Snacks.picker.resume() end, desc = 'Resume', },
  { '<leader>pq', function() Snacks.picker.qflist() end, desc = 'Quickfix List', },
  -- { '<leader>pM', function() Snacks.picker.marks() end, desc = 'Marks', },
  -- { '<leader>pm', function() Snacks.picker.man() end, desc = 'Man Pages', },

  { '<leader>s', group = 'search/grep' },
  { '<leader>sa', function() Snacks.picker.autocmds() end, desc = 'Autocmds', },
  { '<leader>sC', function() Snacks.picker.commands() end, desc = 'Commands', },
  { '<leader>sh', function() Snacks.picker.help() end, desc = 'Help Pages', },
  { '<leader>sH', function() Snacks.picker.highlights() end, desc = 'Highlights', },
  { '<leader>si', function() Snacks.picker.icons() end, desc = 'Icons', },
  { '<leader>sk', function() Snacks.picker.keymaps() end, desc = 'Keymaps', },
  { '<leader>su', function() Snacks.picker.undo() end,desc = 'Undotree', },

  { '<leader>y', group = 'toggle' },
  
  { '<leader>z', function() Snacks.picker.zoxide() end, desc = 'Zoxide', icon = { icon = '󰄻 ' }, },
})

-- dual pickers {{{2
-- stylua: ignore
local function map_pickers(key, path, desc)
  return {
    { '<leader>f' .. key, function() Snacks.picker.files({cwd = path }) end, desc = desc, },
    { '<leader>s' .. key, function() Snacks.picker.grep({ cwd = path }) end, desc = desc, },
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

-- snacks toggles {{{2
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
-- require('munchies.toggle').translucency():map('<leader>ub', { desc = 'Toggle Translucent Background' })
-- require('snacks.toggle').virtual_text():map('<leader>uv', { desc = 'Toggle Virtual Text' })
-- require('snacks.toggle').color_column():map('<leader>u\\', { desc = 'Toggle Color Column' })
-- snacks profiler {{{2
wk.add({
  { '<leader>dp', group = 'profiler' },
  -- stylua: ignore
  { '<leader>dps', function() Snacks.profiler.scratch() end, desc = 'Profiler Scratch Buffer' } })
Snacks.toggle.profiler():map('<leader>dpp')
Snacks.toggle.profiler_highlights():map('<leader>dph')
-- }}}1

-- ui {{{2
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

vim.keymap.set({ 'i', 'n', 's' }, '<esc>', function()
  vim.cmd('noh')
  -- TODO: set up
  -- LazyVim.cmp.actions.snippet_stop()
  return '<esc>'
end, { expr = true, desc = 'Escape and Clear hlsearch' })
