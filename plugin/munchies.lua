-- Section: Keymaps [[
vim.keymap.set({ 'i', 'n', 's' }, '<esc>', function()
  vim.cmd('noh')
  return '<Esc>'
end, { expr = true, desc = 'Escape and Clear hlsearch' })

-- stylua: ignore start
local function map_pickers(key, picker_opts, keymap_opts)
  vim.keymap.set('n', '<leader>f' .. key, function() Snacks.picker.files(picker_opts) end, keymap_opts)
  vim.keymap.set('n', '<leader>s' .. key, function() Snacks.picker.grep(picker_opts) end, keymap_opts)
end

map_pickers('c', {cwd=vim.fn.stdpath('config'), ft={'lua','vim'}}, {desc = 'Config Files'})
map_pickers('.', {cwd=os.getenv('HOME') .. '/.local/share/chezmoi', hidden=true}, {desc = 'Dotfiles'})

local function pick_dir(key, dir, picker_opts)
  -- local opts = vim.tbl_extend('force', { cwd = dir }, picker_opts or {})
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
vim.keymap.set('n', '<leader>uI', function() vim.treesitter.inspect_tree(); vim.api.nvim_input('I') end, { desc = 'Inspect Tree' })

vim.keymap.set({ 'n', 't' }, '<c-\\>', function() Snacks.terminal.toggle() end)
-- vim.keymap.set({ 'n', 't' }, ',,', function() Snacks.terminal.toggle() end)
-- stylua: ignore end
local mods = vim.loader.find('*', { all = true })
local config_path = vim.fn.stdpath('config')

-- filter only modules under config
mods = vim.tbl_filter(function(m)
  return m.modpath:find(config_path, 1, true) == 1
end, mods)

local seen = {}

for _, m in ipairs(mods) do
  local char_idx = m.modname:sub(1, 1)

  -- prefer init.lua if it exists
  local init_file = vim.fs.joinpath(m.modpath, 'init.lua')
  local file_to_edit = vim.fn.filereadable(init_file) == 1 and init_file or m.modpath

  if not vim.tbl_contains(seen, char_idx) then
    seen[#seen + 1] = char_idx
    vim.keymap.set('n', '<Bslash>' .. char_idx, function()
      vim.cmd.edit(file_to_edit)
    end, { desc = 'Edit ' .. m.modname })
  end
end
-- ]]

-- Section: Toggles [[
Snacks.toggle.profiler():map('<leader>dpp')
Snacks.toggle.profiler_highlights():map('<leader>dph')
Snacks.toggle.animate():map('<leader>ua')
Snacks.toggle.diagnostics():map('<leader>ud')
Snacks.toggle.dim():map('<leader>uD')
Snacks.toggle.treesitter():map('<leader>ut')
Snacks.toggle.indent():map('<leader>ug')
Snacks.toggle.scroll():map('<leader>us')
Snacks.toggle.words():map('<leader>uw')
Snacks.toggle.zoom():map('<leader>uZ')
-- FIXME: 
-- local munchies_toggle = require('nvim.snacks.toggle')
--
-- munchies_toggle
--   .translucency()
--   :map('<leader>ub', { desc = 'Toggle Translucent Background' })
-- munchies_toggle.virtual_text():map('<leader>uv', { desc = 'Toggle Virtual Text' })
-- munchies_toggle.color_column():map('<leader>u\\', { desc = 'Toggle Color Column' })
-- munchies_toggle.winborder():map('<leader>uW', { desc = 'Toggle Window Border' })
-- munchies_toggle.laststatus():map('<leader>ul', { desc = 'Toggle Laststatus' })
-- ]]

-- Section: Commands [[
local command = vim.api.nvim_create_user_command

command('GitBlameLine', function()
  local line_number = vim.fn.line('.')
  local filename = vim.api.nvim_buf_get_name(0)
  print(
    vim.system({ 'git', 'blame', '-L', line_number .. ',+1', filename }):wait().stdout
  )
end, { desc = 'Print the git blame for the current line' })

-- `Snacks` Ex functions
command('Scratch', function(opts)
  if opts.bang == true then
    Snacks.scratch.select()
  else
    Snacks.scratch()
  end
end, {
  bang = true,
})

local function to_camel_case(str)
  return str
    :gsub('_%a', function(c)
      return c:sub(2):upper()
    end)
    :gsub('^%l', string.upper)
end

local skip = { 'Lazy' }
-- dynamically create vim commands for each picker
for name, picker in pairs(Snacks.picker) do
  if type(picker) == 'function' then
    local cmd = to_camel_case(name)
    if vim.fn.exists(':' .. cmd) ~= 2 and not vim.list_contains(skip, cmd) then
      command(cmd, function()
        picker()
      end, {
        desc = 'Snacks Picker: ' .. cmd,
      })
    end
  end
end
-- ]]

-- vim:fdm=marker:foldmarker=[[,]]
