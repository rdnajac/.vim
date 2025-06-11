local wk = require('which-key')

-- debug/health {{{
local function command(lhs, cmd, opts)
  opts = opts or {}
  opts.desc = opts.desc or cmd
  return { lhs, '<Cmd>' .. cmd .. '<CR>', opts }
end

local function health(lhs, cmd, opts)
  opts = opts or {}
  opts.desc = opts.desc or cmd
  return { lhs, '<Cmd>checkhealth ' .. cmd .. '<CR>', opts }
end

wk.add({
  { '<leader>d', group = 'debug' },
  command('<leader>da', 'ALEInfo'),
  command('<leader>db', 'BlinkCmp status'),
  { '<leader>dc', ':=vim.lsp.get_clients()[1].server_capabilities<CR>', desc = 'LSP Capabilities' },
  command('<leader>dd', 'LazyDev debug'),
  command('<leader>dl', 'LazyDev lsp'),
  command('<leader>dH', 'LazyHealth'),
  { '<leader>dS', ':=require("snacks").meta.get()<CR>', desc = 'Snacks' },
  { '<leader>dw', ':=vim.lsp.buf.list_workspace_folders()<CR>', desc = 'LSP Workspace Folders' },

  { '<leader>dh', group = 'health', icon = { icon = '' } },
  health('<leader>dhc', 'config'),
  health('<leader>dhk', 'which-key'),
  health('<leader>dhs', 'snacks'),
})

-- stylua: ignore
local function map_pickers(key, path, desc)
  return {
    { '<leader>f' .. key, function() Snacks.picker.files({cwd = path }) end, desc = desc, },
    { '<leader>s' .. key, function() Snacks.picker.grep({ cwd = path }) end, desc = desc, },
  }
end

wk.add({
  map_pickers('c', vim.fn.stdpath('config'), 'Config Files'),
  map_pickers('G', vim.fn.expand('~/GitHub/'), 'GitHub Repos'),
  map_pickers('L', vim.fn.stdpath('data') .. '/lazy/LazyVim', 'LazyVim'),
  map_pickers('P', vim.fn.stdpath('data') .. '/lazy', 'Plugins'),
  map_pickers('S', vim.fn.stdpath('data') .. '/lazy/snacks.nvim', 'Snacks'),
  map_pickers('V', vim.fn.expand('$VIMRUNTIME'), '$VIMRUNTIME'),
})

-- stylua: ignore
local function map_config(lhs, mod)
  return { lhs, function() require('util.togo').config(mod) end, desc = mod, }
end

-- stylua: ignore
wk.add({
  map_config('\\a', 'autocmds'),
  map_config('\\o', 'options/init'),
  map_config('\\k', 'keymaps'),
  map_config('\\i', 'lazy/init'),
  map_config('\\s', 'lazy/spec/init'),
})

wk.add({
  { '<leader>l', group = 'Lazy' },
  { '<leader>ll', '<Cmd>Lazy<CR>', desc = 'Lazy' },
  {
    '<leader>lx',
    function()
      LazyVim.extras.show()
    end,
    desc = 'Lazy Extras',
  },
})

-- stylua: ignore
wk.add({
  { 'gL', function() require('util.togo').lazy() end, desc = 'Goto LazyVim module' },
  { 'gx', function() require('util.togo').gx() end, desc = 'Open with system app' },

  { '\\\\', function() Snacks.dashboard.open() end, desc = 'Snacks Dashboard', },
  { ',,', function() Snacks.terminal.toggle() end, desc = 'Snacks Terminal', mode = { 'n', 't' } },
  { '<leader>.', function() Snacks.scratch() end, desc = 'Toggle Scratch Buffer', },
  { '<leader>>', function() Snacks.scratch.select() end, desc = 'Select Scratch Buffer', },

  { '<leader>a', icon = { icon = ' ', color = 'azure' }, desc = 'Select All' },

  { '<leader>bd', function() Snacks.bufdelete() end, desc = 'Delete Buffer', mode = 'n' },

  { '<leader>c', group = 'code' },
  { '<leader>cz', function() require("munchies.picker").chezmoi() end, desc = 'Chezmoi', },

  { '<leader>dp', group = 'profiler' },
  { '<leader>dps', function() Snacks.profiler.scratch() end, desc = 'Profiler Scratch Buffer', },

  { '<leader>f', group = 'file/find', icon = { color = 'azure' } },
  { '<leader>fC', function() Snacks.rename.rename_file() end, desc = 'Change (rename) File on disk', },
  { '<leader>ff', function() Snacks.picker.files({ cwd = Snacks.git.get_root() }) end, desc = 'Explorer (git root)', },
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

  { '<leader>s', group = 'search/grep' },

  { '<leader>u', group = 'ui', icon = { icon = '󰙵 ', color = 'cyan' } },
  { '<leader>uC', function() Snacks.picker.colorschemes() end, desc = 'Colorschemes', icon = { icon = ' ', color = 'yellow' }, },
  { '<leader>ui', function() vim.show_pos() end, desc = 'Inspect Pos' },
  { '<leader>uI', function() vim.treesitter.inspect_tree() vim.api.nvim_input('I') end, { desc = 'Inspect Tree' }},
  { '<leader>un', function() Snacks.notifier.hide() end, desc = 'Dismiss Notifications' },
  { '<leader>ur', '<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>', desc = 'Redraw/Clear/Diff' },
  { '<leader>uz', function() Snacks.zen() end, desc = 'Zen Mode', icon = { icon = ' ', color = 'blue' }, },

  { '~', group = 'toggle' },
})

-- stylua: ignore
wk.add({
  { '<localleader>p', function() Snacks.picker.lazy() end, desc = 'Search for Plugin Spec', },

  { '<leader>r', '<Cmd>Restart<CR>', desc = 'Restart Neovim', icon = { icon = '' } },
  -- { '<leader>r', function() require('util.restart') end, desc = 'Restart Neovim', icon = { icon = '' } },
  { '<leader>/', function() Snacks.picker.grep() end, desc = 'Grep (Root Dir)', icon = { icon = ' ' }, },
  { '<leader>,', function() Snacks.picker.buffers() end, desc = 'Buffers', },
  { '<leader>F', function() Snacks.picker.smart() end, desc = 'Smart Find Files', },
  { '<leader>n', function() Snacks.picker.notifications() end, desc = "Notification History" },
  { '<leader>U', function() Snacks.picker.undo() end,desc = 'Undotree', },
  { '<leader>h', function() Snacks.picker.help() end, desc = 'Help Pages', },
  { '<leader>z', function() Snacks.picker.zoxide() end, desc = 'Zoxide', icon = { icon = '󰄻 ' }, },

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

  { '<leader>fb', function() Snacks.picker.buffers() end, desc = 'Buffers', },
  { '<leader>fB', function() Snacks.picker.buffers({ hidden = true, nofile = true }) end, desc = 'Buffers (all)', },
  { '<leader>sb', function() Snacks.picker.lines() end, desc = 'Buffer Lines', },
  { '<leader>sB', function() Snacks.picker.grep_buffers() end, desc = 'Grep Open Buffers', },
})

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

Snacks.toggle.profiler():map('<leader>dpp')
Snacks.toggle.profiler_highlights():map('<leader>dph')

Snacks.toggle
  .option('showtabline', {
    off = 0,
    on = vim.o.showtabline > 0 and vim.o.showtabline or 2,
    name = 'Tabline',
  })
  :map('<leader>uA')

Snacks.toggle
  .option('conceallevel', {
    off = 0,
    on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2,
    name = 'Conceal Level',
  })
  :map('<leader>uc')

Snacks.toggle.animate():map('<leader>ua')
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

vim.keymap.set('n', '<leader>cd', function()
  vim.ui.input({ prompt = 'Change Directory: ', default = vim.fn.getcwd() }, function(input)
    if input then
      vim.cmd('cd ' .. input)
    end
    vim.cmd('pwd')
  end)
end, { desc = 'Change Directory' })

vim.keymap.set('n', '<leader>q', function()
  if #vim.fn.getbufinfo({ buflisted = 1 }) > 1 then
    -- vim.cmd('bdelete')
    Snacks.bufdelete()
  else
    vim.cmd('quit')
  end
end, { desc = 'Smart Quit' })

vim.keymap.set({ 'i', 'n', 's' }, '<esc>', function()
  vim.cmd('noh')
  -- LazyVim.cmp.actions.snippet_stop()
  return '<esc>'
end, { expr = true, desc = 'Escape and Clear hlsearch' })

-- better escape " {{{
local map_combo = require('mini.keymap').map_combo

-- Modes: i = insert, c = command, x = visual, s = select
local modes = { 'i', 'c', 'v', 's' }

-- Map both 'jk' and 'kj' to <Esc> in normal-ish modes
for _, combo in ipairs({ 'jk', 'kj' }) do
  map_combo(modes, combo, '<BS><BS><Esc>')
end

-- Terminal mode: 'jk' and 'kj' to <C-\><C-n>
for _, combo in ipairs({ 'jk', 'kj' }) do
  map_combo('t', combo, '<BS><BS><C-\\><C-n>')
end
-- }}}

vim.keymap.set('n', '<leader>D', function()
  require('util.debugprint').insert()
end, { desc = 'Insert Debug Print' })

vim.keymap.set('n', '_', function()
  local cwd = vim.fn.getcwd()
  local target = vim.fn.expand('%:p:h')
  if cwd == target then
    target = require('lazyvim.util').root.get()
  end
  vim.cmd('cd ' .. target .. ' | pwd')
end)
-- vim: fdm=marker fdl=1
