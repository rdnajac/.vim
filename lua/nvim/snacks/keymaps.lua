vim.keymap.set('n', '<leader>gg', function()
  Snacks.lazygit()
  vim.cmd.startinsert()
end, { desc = 'Lazygit' })

-- stylua: ignore start
local function map_pickers(key, picker_opts, keymap_opts)
  vim.keymap.set('n', '<leader>f' .. key, function() Snacks.picker.files(picker_opts) end, keymap_opts)
  vim.keymap.set('n', '<leader>s' .. key, function() Snacks.picker.grep(picker_opts) end, keymap_opts)
end

map_pickers('c', {cwd=vim.fn.stdpath('config'), ft={'lua','vim'}}, {desc = 'Config Files'})
map_pickers('d', {cwd=vim.fn.stdpath('data')}, {desc = 'Data Files'})
map_pickers('.', {cwd=os.getenv('HOME') .. '/.local/share/chezmoi', hidden=true}, {desc = 'Dotfiles'})

local function pick_dir(key, dir, picker_opts)
  local opts = picker_opts or {}
  opts.cwd = vim.fn.expand(dir)
  map_pickers(key, opts, { desc = dir })
end

pick_dir('G', '~/GitHub/')
pick_dir('v', '$VIMRUNTIME')
pick_dir('V', '$VIM')
pick_dir('p', '~/.vim/pack', {ignored=true, hidden=false})
pick_dir('P', vim.g.plug_home, {ft={'lua','vim'}})
-- TODO: this should be items not cwd
-- pick_dir('N', vim.api.nvim_list_runtime_paths(), {ft={'lua','vim'}})

vim.keymap.set('n', ',,', function() Snacks.picker.buffers() end, { desc = 'Buffers' })
vim.keymap.set('n', '<leader>bb', function() Snacks.picker.buffers() end, { desc = 'Buffers' })
vim.keymap.set('n', '<leader>bB', function() Snacks.picker.buffers({hidden=true, nofile= true}) end, { desc = 'Buffers (all)' })
vim.keymap.set('n', '<leader>bl', function() Snacks.picker.lines() end, { desc = 'Buffer Lines' })
vim.keymap.set('n', '<leader>bg', function() Snacks.picker.grep_buffers() end, { desc = 'Grep Open Buffers' })
vim.keymap.set('n', '<leader>uz', function() Snacks.zen() end, { desc = 'Zen Mode' })
vim.keymap.set('n', '<leader>ui', function() vim.show_pos() end, { desc = 'Inspect Pos' })

vim.keymap.set({ 'n', 't' }, '<c-\\>', function() Snacks.terminal.toggle() end)
-- vim.keymap.set({ 'n', 't' }, ',,', function() Snacks.terminal.toggle() end)
-- stylua: ignore end

-- Section: Toggles
-- see `toggle.lua` for more toggles
Snacks.toggle.profiler():map('<leader>dpp')
Snacks.toggle.profiler_highlights():map('<leader>dph')
Snacks.toggle.animate():map('<leader>ua')
Snacks.toggle.diagnostics():map('<leader>ud')
Snacks.toggle.dim():map('<leader>uD')
Snacks.toggle.indent():map('<leader>ug')
-- Snacks.toggle.scroll():map('<leader>uS')
Snacks.toggle.option('wrap', { name = 'Wrap' }):map('<leader>uw')
Snacks.toggle.words():map('<leader>uW')
Snacks.toggle.zoom():map('<leader>uZ')
Snacks.toggle.option('spell', { name = 'Spelling' }):map('<leader>us')
Snacks.toggle.option('relativenumber', { name = 'Relative Number' }):map('<leader>uL')
Snacks.toggle.line_number():map('<leader>ul')
-- Snacks.toggle.inlay_hints():map('<leader>uh') -- XXX: in lsp.lua
-- TODO: toggle copilot

-- stylua: ignore
local keys = {
  -- Top Pickers & Explorer
  { '<leader><space>', function() Snacks.picker.smart() end, desc = 'Smart Find Files' },
  { '<leader>,', function() Snacks.picker.buffers() end, desc = 'Buffers' },
  { '<leader>/', function() Snacks.picker.grep() end,                desc = 'Grep' },
  { '<leader>e', function() Snacks.explorer() end,                   desc = 'File Explorer' },
  -- find
  { '<leader>fb', function() Snacks.picker.buffers() end,            desc = 'Buffers' },
  { '<leader>ff', function() Snacks.picker.files() end,              desc = 'Find Files' },
  { '<leader>fg', function() Snacks.picker.git_files() end,          desc = 'Find Git Files' },
  -- { '<leader>fp', function() Snacks.picker.projects() end,           desc = 'Projects' },
  { '<leader>fr', function() Snacks.picker.recent() end,             desc = 'Recent' },
  -- git TODO: check against vimrc
  -- { '<leader>gb', function() Snacks.picker.git_branches() end,       desc = 'Git Branches' },
  -- { '<leader>gl', function() Snacks.picker.git_log() end,            desc = 'Git Log' },
  -- { '<leader>gL', function() Snacks.picker.git_log_line() end,       desc = 'Git Log Line' },
  -- { '<leader>gs', function() Snacks.picker.git_status() end,         desc = 'Git Status' },
  -- { '<leader>gS', function() Snacks.picker.git_stash() end,          desc = 'Git Stash' },
  -- { '<leader>gd', function() Snacks.picker.git_diff() end,           desc = 'Git Diff (Hunks)' },
  -- { '<leader>gf', function() Snacks.picker.git_log_file() end,       desc = 'Git Log File' },

  -- search/grep
  { '<leader>s"', function() Snacks.picker.registers() end,          desc = 'Registers' },
  { '<leader>s/', function() Snacks.picker.search_history() end,     desc = 'Search History' },
  { '<leader>s:', function() Snacks.picker.command_history() end,    desc = 'Command History' },
  { '<leader>sa', function() Snacks.picker.autocmds() end,           desc = 'Autocmds' },
  { '<leader>sb', function() Snacks.picker.lines() end,              desc = 'Buffer Lines' },
  { '<leader>sB', function() Snacks.picker.grep_buffers() end,       desc = 'Grep Open Buffers' },
  -- { '<leader>sc', function() Snacks.picker.command_history() end,    desc = 'Command History' },
  { '<leader>sC', function() Snacks.picker.commands() end,           desc = 'Commands' },
  { '<leader>sd', function() Snacks.picker.diagnostics() end,        desc = 'Diagnostics' },
  { '<leader>sD', function() Snacks.picker.diagnostics_buffer() end, desc = 'Buffer Diagnostics' },
  { '<leader>sh', function() Snacks.picker.help() end,               desc = 'Help Pages' },
  { '<leader>sH', function() Snacks.picker.highlights() end,         desc = 'Highlights' },
  { '<leader>si', function() Snacks.picker.icons() end,              desc = 'Icons' },
  { '<leader>sj', function() Snacks.picker.jumps() end,              desc = 'Jumps' },
  { '<leader>sk', function() Snacks.picker.keymaps() end,            desc = 'Keymaps' },
  { '<leader>sl', function() Snacks.picker.loclist() end,            desc = 'Location List' },
  { '<leader>sm', function() Snacks.picker.marks() end,              desc = 'Marks' },
  { '<leader>sM', function() Snacks.picker.man() end,                desc = 'Man Pages' },
  { '<leader>sn', function() Snacks.picker.notifications() end,       desc = 'Notification History' },
  { '<leader>sp', function() Snacks.picker.lazy() end,               desc = 'Search for Plugin Spec' },
  { '<leader>sq', function() Snacks.picker.qflist() end,             desc = 'Quickfix List' },
  { '<leader>sR', function() Snacks.picker.resume() end,             desc = 'Resume' },
  { '<leader>su', function() Snacks.picker.undo() end,               desc = 'Undo History' },
  { '<leader>sw', function() Snacks.picker.grep_word() end,          desc = 'Visual selection or word',      mode = { 'n', 'x' } },
  { '<leader>uC', function() Snacks.picker.colorschemes() end,       desc = 'Colorschemes' },
  -- Other
  { '<leader>z',  function() Snacks.zen() end,                       desc = 'Toggle Zen Mode' },
  { '<leader>Z',  function() Snacks.zen.zoom() end,                  desc = 'Toggle Zoom' },
  { '<leader>.',  function() Snacks.scratch() end,                   desc = 'Toggle Scratch Buffer' },
  { '<leader>S',  function() Snacks.scratch.select() end,            desc = 'Select Scratch Buffer' },
  { '<leader>n',  function() Snacks.notifier.show_history() end,     desc = 'Notification History' },
  -- { '<leader>bd', function() Snacks.bufdelete() end,                 desc = 'Delete Buffer' },
  { '<leader>cR', function() Snacks.rename.rename_file() end,        desc = 'Rename File' },
  { '<leader>un', function() Snacks.notifier.hide() end,             desc = 'Dismiss All Notifications' },
  { ']]', function() Snacks.words.jump(vim.v.count1) end, desc = 'Next Reference', mode = { 'n', 't' } },
  { '[[', function() Snacks.words.jump(-vim.v.count1) end, desc = 'Prev Reference', mode = { 'n', 't' } },
  -- LSP
  -- { 'gd',         function() Snacks.picker.lsp_definitions() end, desc = 'Goto Definition' },
  -- { 'gD',         function() Snacks.picker.lsp_declarations() end,desc = 'Goto Declaration' },
  -- { 'gr',         function() Snacks.picker.lsp_references() end, nowait = true, desc = 'References' },
  -- { 'gI',         function() Snacks.picker.lsp_implementations() end, desc = 'Goto Implementation' },
  -- { 'gy',         function() Snacks.picker.lsp_type_definitions() end, desc = 'Goto T[y]pe Definition' },
  -- { '<leader>ss', function() Snacks.picker.lsp_symbols() end, desc = 'LSP Symbols' },
  -- { '<leader>sS', function() Snacks.picker.lsp_workspace_symbols() end, desc = 'LSP Workspace Symbols' },
  -- TODO: make this a func to pull up any doc with pre-defined win opts
  {
    '<leader>N',
    desc = 'Neovim News',
    function()
      Snacks.win({
        file = vim.api.nvim_get_runtime_file('doc/news.txt', false)[1],
        width = 0.6,
        height = 0.6,
        border = 'double',
        wo = {
          spell = false,
          wrap = false,
          signcolumn = 'yes',
          statuscolumn = ' ',
          conceallevel = 3,
        },
      })
    end,
  },
}

require('which-key').add(keys)

-- no hlsearch on <Esc>
-- vimscript: nnoremap <expr> <Esc> ':nohlsearch\<CR><Esc>'
-- vim.keymap.set({ 'i', 'n', 's' }, '<Esc>', function()
--   vim.cmd.nohlsearch()
--   return '<Esc>'
-- end, { expr = true, desc = 'Escape and Clear hlsearch' })

Snacks.util.on_key('<Esc>', function()
  vim.cmd.nohlsearch()
end)
-- print(Snacks.util.keycode('<Esc>'))
