vim.keymap.set('n', 'zS', vim.show_pos, { desc = 'Inspect Pos' })

vim.keymap.set(
  'n',
  '<leader>ur',
  '<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>',
  { desc = 'Redraw/Clear hlsearch/Diff Update' }
)

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

-- stylua: ignore start
require('which-key').add({
  { '<leader>l', '<Cmd>Lazy<CR>', desc = 'Lazy' },
  { '<leader>L', function() LazyVim.extras.show() end, desc = 'Lazy Extras' },
  { '<leader>R', '<Cmd>restart<CR>', desc = 'Restart Neovim', icon = { icon = '' } },

  { 'gL', function() require('nvim.lazy.goto') end, { desc = 'Goto LazyVim module' }, },

  { '<leader>.', function() Snacks.scratch() end, desc = 'Toggle Scratch Buffer', },
  { '<leader>>', function() Snacks.scratch.select() end, desc = 'Select Scratch Buffer', },
  -- { '<leader>n', function() Snacks.picker.notifications() end, desc = 'Notification History', },
  -- { '<leader>un', function() Snacks.notifier.hide() end, desc = 'Dismiss All Notifications', },

  { '<leader>bd', function() Snacks.bufdelete() end, desc = 'Delete Buffer', mode = 'n' },

  { '<leader>c', group = 'code' },
  { '<leader>cz', function() require("munchies.picker").chezmoi() end, desc = 'Chezmoi', },

  { '<leader>d', group = 'debug' },
  { '<leader>da', '<Cmd>ALEInfo<CR>', desc = 'Ale' },
  { '<leader>db', '<Cmd>BlinkCmp status<CR>', desc = 'Blink'},
  { '<leader>dc', ':=vim.lsp.get_clients()[1].server_capabilities<CR>', desc = 'LSP Capabilities' },
  { '<leader>dd', '<Cmd>LazyDev lsp<CR>', desc = 'LazyDev lsp' },
  { '<leader>dD', '<Cmd>LazyDev debug<CR>', desc = 'LazyDev debug' },
  { '<leader>dl', '<Cmd>checkhealth lsp<CR>', desc = 'LSP' },
  { '<leader>dL', '<Cmd>Lazy! load all <Bar> checkhealth<CR>', desc = 'LazyHealth', mode = 'n' },
  { '<leader>ds', '<Cmd>checkhealth snacks<CR>', desc = 'Snacks Health' },
  { '<leader>dS', ':=require("snacks").meta.get()<CR>', desc = 'Snacks' },
  { '<leader>dw', ':=vim.lsp.buf.list_workspace_folders()<CR>', desc = 'LSP Workspace Folders' },

  { '<leader>dp', group = 'profiler' },
  { '<leader>dps', function() Snacks.profiler.scratch() end, desc = 'Profiler Scratch Buffer', },

  { '<leader>f', group = 'file/find' },
  { '<leader>fC', function() Snacks.rename.rename_file() end, desc = 'Change (rename) File on disk', },
  { '<leader>ff', function() Snacks.picker.files({ cwd = Snacks.git.get_root() }) end, desc = 'Explorer (git root)', },
  { '<leader>fr', function() Snacks.picker.recent() end, desc = 'Recent' },
  { '<leader>fR', function() Snacks.picker.recent({ filter = { cwd = true } }) end, desc = 'Recent (cwd)', },

  { '<leader>s', group = 'search/grep' },
  { '<leader>t', group = 'toggle' },

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

  { ',,', function() Snacks.terminal.toggle() end, desc = 'Snacks Terminal', mode = { 'n', 't' } },

  { '<leader>u', group = 'ui', icon = { icon = '󰙵 ', color = 'cyan' } },
  { '<leader>uC', function() Snacks.picker.colorschemes() end, desc = 'Colorschemes', icon = { icon = ' ', color = 'yellow' }, },
  { '<leader>ui', function() vim.show_pos() end, desc = 'Inspect Pos' },
  { '<leader>un', function() Snacks.notifier.hide() end, desc = 'Dismiss Notifications' },
  { '<leader>uz', function() Snacks.zen() end, desc = 'Zen Mode', icon = { icon = ' ', color = 'blue' }, },
})

-- stylua: ignore
require('which-key').add({
  { '<localleader>p', function() Snacks.picker.lazy() end, desc = 'Search for Plugin Spec', },
  { '<leader>/', function() Snacks.picker.grep() end, desc = 'Grep (Root Dir)', icon = { icon = ' ' }, },
  { '<leader>,', function() Snacks.picker.buffers() end, desc = 'Buffers', },
  { '<leader>F', function() Snacks.picker.smart() end, desc = 'Smart Find Files', },
  { '<leader>n', function() Snacks.picker.notifications() end, desc = "Notification History" },
  { '<leader>z', function() Snacks.picker.zoxide() end, desc = 'Zoxide', icon = { icon = '󰄻 ' }, },

  { '<leader>p', group = 'Pickers' },
  { '<leader>P', function() Snacks.picker() end, desc = 'Pickers', icon = { icons = ' ' }, },
  { '<leader>pa', function() Snacks.picker.autocmds() end, desc = 'Autocmds', },
  { '<leader>pc', function() Snacks.picker.cliphist() end, desc = 'Commands', },
  { '<leader>pC', function() Snacks.picker.commands() end, desc = 'Commands', },
  { '<leader>p:', function() Snacks.picker.command_history() end, desc = 'Command History', },
  { '<leader>pd', function() Snacks.picker.diagnostics() end, desc = 'Diagnostics', },
  { '<leader>pD', function() Snacks.picker.diagnostics_buffer() end, desc = 'Buffer Diagnostics', },
  { '<leader>ph', function() Snacks.picker.help() end, desc = 'Help Pages', },
  { '<leader>pH', function() Snacks.picker.highlights() end, desc = 'Highlights', },
  { '<leader>pi', function() Snacks.picker.icons() end, desc = 'Icons', },
  { '<leader>pj', function() Snacks.picker.jumps() end, desc = 'Jumps', },
  { '<leader>pk', function() Snacks.picker.keymaps() end, desc = 'Keymaps', },
  { '<leader>pm', function() Snacks.picker.man() end, desc = 'Man Pages', },
  { '<leader>pM', function() Snacks.picker.marks() end, desc = 'Marks', },
  { '<leader>pq', function() Snacks.picker.qflist() end, desc = 'Quickfix List', },
  { '<leader>pR', function() Snacks.picker.resume() end, desc = 'Resume', },
  { '<leader>pu', function() Snacks.picker.undo() end,desc = 'Undotree', },

  { '<leader>fb', function() Snacks.picker.buffers() end, desc = 'Buffers', },
  { '<leader>fB', function() Snacks.picker.buffers({ hidden = true, nofile = true }) end, desc = 'Buffers (all)', },
  { '<leader>sb', function() Snacks.picker.lines() end, desc = 'Buffer Lines', },
  { '<leader>sB', function() Snacks.picker.grep_buffers() end, desc = 'Grep Open Buffers', },

  { '<leader>fc', function() Snacks.picker.files({cwd = vim.fn.stdpath("config") }) end, desc = 'Config Files', },
  { '<leader>sc', function() Snacks.picker.grep({ cwd = vim.fn.stdpath('config') }) end, desc = 'Grep Config Files', },
  { '<leader>fL', function() Snacks.picker.files({cwd = vim.fn.stdpath('data') .. '/lazy/LazyVim' }) end, desc = 'LazyVim Files', },
  { '<leader>sL', function() Snacks.picker.grep({ cwd = vim.fn.stdpath('data') .. '/lazy/LazyVim' }) end, desc = 'LazyVim File', },
  { '<leader>fG', function() Snacks.picker.files({cwd = vim.fn.expand('~/GitHub/') }) end, desc = 'GitHub Repos', },
  { '<leader>sG', function() Snacks.picker.grep({ cwd = vim.fn.expand('~/GitHub/') }) end, desc = 'GitHub Repos', },
  { '<leader>fP', function() Snacks.picker.files({cwd = vim.fn.stdpath('data') .. '/lazy' }) end, desc = 'Lazy Plugins', },
  { '<leader>sP', function() Snacks.picker.grep({ cwd = vim.fn.stdpath('data') .. '/lazy' }) end, desc = 'Lazy Plugin File', },
  { '<leader>fS', function() Snacks.picker.files({ cwd = vim.fn.stdpath('data') .. '/lazy/snacks.nvim' }) end, desc = 'Snacks Files', },
  { '<leader>sS', function() Snacks.picker.grep({ cwd = vim.fn.stdpath('data') .. '/lazy/snacks.nvim' }) end, desc = 'Snacks File', },
  { '<leader>fV', function() Snacks.picker.files({cwd = vim.fn.expand('$VIMRUNTIME') }) end, desc = '$VIMRUNTIME', },
  { '<leader>sV', function() Snacks.picker.grep({ cwd = vim.fn.expand('$VIMRUNTIME') }) end, desc = '$VIMRUNTIME', },

  { '<leader>s"', function() Snacks.picker.registers() end, desc = 'Registers', },
  { '<leader>s/', function() Snacks.picker.search_history() end, desc = 'Search History', },
})

-- better escape " {{{1
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

-- § edit shortcuts {{{1
-- TODO: use snacks
--- Display a warning message using Neovim's notification system.
--- @param msg string: The warning message to display.
local function warn(msg)
  vim.notify(msg, vim.log.levels.WARN)
end

--- Edit a file if it is readable, otherwise optionally display a warning.
--- @param file string: The path to the file to edit.
--- @param should_warn? boolean: Whether to warn if the file is not found.
--- @return boolean: True if the file was successfully edited, false otherwise.
local function edit(file, should_warn)
  if vim.fn.filereadable(file) == 1 then
    if Snacks.util.is_float() then
      vim.cmd('q')
    end
    vim.cmd('edit ' .. file)
    return true
  else
    if should_warn then
      warn('File not found: ' .. file)
    end
    return false
  end
end

local edit_config = function(mod)
  return edit(vim.fn.stdpath('config') .. '/lua/config/' .. mod .. '.lua')
end

require('which-key').add({
  { '\\\\', function() Snacks.dashboard.open() end, desc = 'Snacks Dashboard' },
  { '\\i', function() edit_config('lazy/init') end, desc = 'init' },
  { '\\a', function() edit_config('autocmds') end, desc = 'autocmds' },
  { '\\o', function() edit_config('options') end, desc = 'options' },
  { '\\k', function() edit_config('keymaps') end, desc = 'keymaps' },
  { '\\s', function() edit_config('lazy/spec/init') end, desc = 'LazySpec' },
})

-- toggles {{{
Snacks.toggle.profiler():map('<leader>dpp')
Snacks.toggle.profiler_highlights():map('<leader>dph')
Snacks.toggle.option('autochdir'):map('<leader>ta')
Snacks.toggle
.option('showtabline', { off = 0, on = vim.o.showtabline > 0 and vim.o.showtabline or 2, name = 'Tabline' })
:map('<leader>uA')
Snacks.toggle
.option(
  'conceallevel',
  { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2, name = 'Conceal Level' }
)
:map('<leader>uc')
Snacks.toggle.option('relativenumber', { name = 'Relative Number' }):map('<leader>uL')
Snacks.toggle.option('spell', { name = 'Spelling' }):map('<leader>us')
Snacks.toggle.option('laststatus', { off = 0, on = 3 }):map('<leader>uu')
Snacks.toggle.option('wrap', { name = 'Wrap' }):map('<leader>uw')
Snacks.toggle.option('list'):map('<leader>u?')

Snacks.toggle.animate():map('<leader>ua')
Snacks.toggle.diagnostics():map('<leader>ud')
Snacks.toggle.dim():map('<leader>uD')
Snacks.toggle.line_number():map('<leader>ul')
Snacks.toggle.treesitter():map('<leader>uT')
Snacks.toggle.indent():map('<leader>ug')
Snacks.toggle.scroll():map('<leader>uS')
Snacks.toggle.words():map('<leader>uW')
Snacks.toggle.zoom():map('<leader>uZ')

if vim.lsp.inlay_hint then
  Snacks.toggle.inlay_hints():map('<leader>uh')
end

-- Custom toggles
require('munchies.toggle').translucency():map('<leader>ub', { desc = 'Toggle Translucent Background' })
require('munchies.toggle').virtual_text():map('<leader>uv', { desc = 'Toggle Virtual Text' })
require('munchies.toggle').color_column():map('<leader>u\\', { desc = 'Toggle Color Column' })
-- vim: fdm=marker fdl=0
