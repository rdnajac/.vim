-- vim.keymap.set('n', 'zS', vim.showpos)
vim.keymap.set('n', '<leader>ui', vim.show_pos)
vim.keymap.set('n', '<leader>uI', function()
  vim.treesitter.inspect_tree()
  vim.api.nvim_input('I')
end, { desc = 'Inspect Tree' })

Snacks.util.on_key('<Esc>', function()
  vim.cmd.nohlsearch()
  if package.loaded['sidekick'] then
    require('sidekick').clear()
  end
end)

Snacks.util.on_key('<C-Space>', function()
  if package.loaded['sidekick'] then
    require('sidekick').clear()
  end
end)

-- stylua: ignore start
vim.keymap.set('v', '<leader>/', function() Snacks.picker.grep_word() end)
vim.keymap.set({'n','t'}, '<c-\\>', function() Snacks.terminal.toggle() end)
vim.keymap.set('n', '<leader>sW', 'viW<Cmd>lua Snacks.picker.grep_word()<CR>', { desc = 'Grep <cWORD>' })
--stylua: ignore end

local all = { hidden = true, nofile = true } -- opts for buffers (all)
local notifier = true -- TODO:

--- Helper function to create a which-key mapping table
---@param key string The key sequence to map
---@param fn function The function to execute when the key is pressed
---@param desc string Description of the mapping
---@param opts? table Optional additional options (mode, etc.)
---@return table A which-key compatible mapping specification
local function keymap(key, fn, desc, opts)
  opts = opts or {}
  return vim.tbl_extend('force', { key, fn, desc = desc }, opts)
end

-- TODO: find missing descriptions
-- TODO: add groups and icons
-- NOTE: Using helper function `keymap(key, fn, desc, opts?)` to define mappings
-- stylua: ignore
local keys = {
keymap('<leader><space>', function() Snacks.picker.smart() end,   'Smart Find Files'),
keymap('<leader>,', function() Snacks.picker.buffers() end,       'Buffers'),
keymap('<leader>/', function() Snacks.picker.grep() end,          'Grep'),
keymap('<leader>e', function() Snacks.explorer() end,             'File Explorer'),
keymap('<leader>p', function() Snacks.picker.resume() end,        'Resume Picking'),
keymap('<leader>P', function() Snacks.picker() end,               'Snacks Pickers'),

-- buffers
keymap(',,',         function() Snacks.picker.buffers() end,      'Buffers'),
keymap('<leader>bb', function() Snacks.picker.buffers() end,      'Buffers'),
keymap('<leader>bB', function() Snacks.picker.buffers(all) end,   'Buffers (all)'),
keymap('<leader>bl', function() Snacks.picker.lines() end,        'Buffer Lines'),
keymap('<leader>bg', function() Snacks.picker.grep_buffers() end, 'Grep Open Buffers'),
keymap('<leader>bd', function() Snacks.bufdelete() end,           'Delete Buffer'),
keymap('<leader>bD', function() Snacks.bufdelete.other() end,     'Delete Other Buffers'),

-- code
keymap('<leader>cd', function() Snacks.picker.diagnostics() end,          'Diagnostics'),
keymap('<leader>cD', function() Snacks.picker.diagnostics_buffer() end,   'Buffer Diagnostics'),

-- find
keymap('<leader>fb', function() Snacks.picker.buffers() end,      'Buffers'),
keymap('<leader>ff', function() Snacks.picker.files() end,        'Find Files'),
keymap('<leader>fg', function() Snacks.picker.git_files() end,    'Find Git Files'),
keymap('<leader>fp', function() Snacks.picker.projects() end,     'Projects'),
keymap('<leader>fr', function() Snacks.picker.recent() end,       'Recent'),

-- git
keymap('<leader>gB', function() Snacks.gitbrowse() end,           'Git Browse'),
keymap('<leader>gb', function() Snacks.picker.git_branches() end, 'Git Branches'),
keymap('<leader>gd', function() Snacks.picker.git_diff() end,     'Git Diff'),
keymap('<leader>gf', function() Snacks.picker.git_log_file() end, 'Git Log File'),
keymap('<leader>gL', function() Snacks.picker.git_log_line() end, 'Git Log Line'),
keymap('<leader>gl', function() Snacks.picker.git_log() end,      'Git Log'),
keymap('<leader>gs', function() Snacks.picker.git_status() end,   'Git Status'),
keymap('<leader>gS', function() Snacks.picker.git_stash() end,    'Git Stash'),
keymap('<leader>gg', function() Snacks.lazygit() end,             'Lazygit'),

-- search/grep
keymap('<leader>s"', function() Snacks.picker.registers() end,            'Registers'),
keymap('<leader>s/', function() Snacks.picker.search_history() end,       'Search History'),
keymap('<leader>s:', function() Snacks.picker.command_history() end,      'Command History'),
keymap('<leader>sa', function() Snacks.picker.autocmds() end,             'Autocmds'),
keymap('<leader>sb', function() Snacks.picker.lines() end,                'Buffer Lines'),
keymap('<leader>sB', function() Snacks.picker.grep_buffers() end,         'Grep Open Buffers'),
keymap('<leader>sC', function() Snacks.picker.commands() end,             'Commands'),
keymap('<leader>sh', function() Snacks.picker.help() end,                 'Help Pages'),
keymap('<leader>sH', function() Snacks.picker.highlights() end,           'Highlights'),
keymap('<leader>si', function() Snacks.picker.icons() end,                'Icons'),
keymap('<leader>sj', function() Snacks.picker.jumps() end,                'Jumps'),
keymap('<leader>sk', function() Snacks.picker.keymaps() end,              'Keymaps'),
keymap('<leader>sl', function() Snacks.picker.loclist() end,              'Location List'),
keymap('<leader>sm', function() Snacks.picker.marks() end,                'Marks'),
keymap('<leader>sM', function() Snacks.picker.man() end,                  'Man Pages'),
keymap('<leader>sn', function() Snacks.picker.notifications() end,        'Notification History'),
keymap('<leader>sq', function() Snacks.picker.qflist() end,               'Quickfix List'),
keymap('<leader>sR', function() Snacks.picker.resume() end,               'Resume'),
keymap('<leader>sw', function() Snacks.picker.grep_word() end,            'Grep <cword>'),
keymap('<leader>su', function() Snacks.picker.undo() end,                 'Undo History'),
-- ui
keymap('<leader>uC', function() Snacks.picker.colorschemes() end,         'Colorschemes'),
keymap('<leader>uz', function() Snacks.zen() end,                         'Zen Mode'),
keymap('<leader>z',  function() Snacks.zen() end,                         'Toggle Zen Mode'),
keymap('<leader>Z',  function() Snacks.zen.zoom() end,                    'Toggle Zoom'),
-- other
keymap('<leader>.',  function() Snacks.scratch() end,                     'Toggle Scratch Buffer'),
keymap('<leader>S',  function() Snacks.scratch.select() end,              'Select Scratch Buffer'),
keymap('<leader>un', function() Snacks.notifier.hide() end,               'Dismiss Notifications'),
keymap('<leader>cR', function() Snacks.rename.rename_file() end,          'Rename File'),
keymap('<leader>fC', function() Snacks.rename.rename_file() end,          'Rename File'),
-- LSP
keymap('grd', function() Snacks.picker.lsp_definitions() end,             'LSP Definition'),
keymap('grD', function() Snacks.picker.lsp_declarations() end,            'LSP Declaration'),
keymap('grR', function() Snacks.picker.lsp_references() end,              'LSP References'),
keymap('grI', function() Snacks.picker.lsp_implementations() end,         'LSP Implementation'),
keymap('grT', function() Snacks.picker.lsp_type_definitions() end,        'LSP Type Definition'),
keymap('<leader>ss', function() Snacks.picker.lsp_symbols() end,          'LSP Symbols'),
keymap('<leader>sS', function() Snacks.picker.lsp_workspace_symbols() end,'LSP Workspace Symbols'),
keymap(']]', function() Snacks.words.jump(vim.v.count1) end, 'Next Reference', {mode={'n','t'}}),
keymap('[[', function() Snacks.words.jump(-vim.v.count1)end, 'Prev Reference', {mode={'n','t'}}),
  keymap('<leader>N', function()
      Snacks.zen({win={file=vim.api.nvim_get_runtime_file('doc/news.txt', false)[1]}})
    end, 'Neovim News'),
  keymap('<leader>n', function()
      return (notifier and Snacks.notifier.show_history or Snacks.picker.notifications)()
    end, 'Notification History'),
}

--- Create a pair of which-key specs for mapping a file picker and a grep picker
---@param desc string Description of the mapping
---@param key string The key to bind the pickers to (appended to <leader>f and <leader>s)
---@param dir string Directory path for the pickers
---@param picker_opts? table Options to pass to the pickers
---@return table A pair of which-key compatible mapping specifications
local function picker_pair(desc, key, dir, picker_opts)
  local opts = picker_opts or {}
  opts.cwd = vim.fn.expand(dir)
  -- stylua: ignore
  return {
    keymap('<leader>f' .. key, function() Snacks.picker.files(opts) end, desc),
    keymap('<leader>s' .. key, function() Snacks.picker.grep(opts)  end, desc),
  }
end

local picker_pairs = {
  Dotfiles = { '.', vim.g['chezmoi#source_dir_path'], { hidden = true } },
  DataFiles = { 'd', vim.fn.stdpath('data') },
  GitHubRepos = { 'G', '~/GitHub/' },
  ConfigFiles = { 'c', vim.fn.stdpath('config'), { ft = { 'lua', 'vim' } } },
  VIM = { 'V', '$VIM', { ft = { 'lua', 'vim' } } },
  VIMRUNTIME = { 'v', '$VIMRUNTIME', { ft = { 'lua', 'vim' } } },
  Plugins = { 'P', vim.g.plug_home, { ft = { 'lua', 'vim' } } },
}

-- add the mappings to the keys table
for desc, args in pairs(picker_pairs) do
  local key, dir, opts = unpack(args)
  vim.list_extend(keys, picker_pair(desc, key, dir, opts))
end

require('nvim.snacks.toggle')
-- require('which-key').add(keys)
return keys
