-- Section: Housekeeping [[
---@type 'netrw'|'snacks'|'oil'
vim.g.default_file_explorer = 'oil'

-- disable netrw if using another file explorer
vim.g.loaded_netrw = vim.g.default_file_explorer == 'netrw' and 1 or nil

-- set the plugin directory if the new native package manager is available
if vim.is_callable(vim.pack.add) then
  vim.g.plug_home =
    vim.fs.joinpath(vim.fn.stdpath('data'), 'site', 'pack', 'core', 'opt')
end
-- ]]
-- Section: Options and `vimrc` [[
-- set these options first so it is apparent if vimrc overrides them
-- also try `:options`
vim.o.cmdheight = 0
vim.o.laststatus = 3
vim.o.pumblend = 0
-- vim.o.smoothscroll = true
vim.o.winborder = 'rounded'

-- load vimrc!
vim.cmd.runtime('vimrc')
-- ]]
-- Section: Core Setup [[
vim.loader.enable()

-- Override require to handle errors gracefully
_G.Require = function(module)
  local ok, mod = xpcall(require, debug.traceback, module)
  if not ok then
    vim.schedule(function()
      error(mod) -- TODO: why are we scheduling the error?
    end)
    return nil
  end
  return mod
end

Require('vim._extui').enable({})

_G.nvim = vim.defaulttable(function(k)
  return require('nvim.' .. k)
end)

-- override vim.notify to provide additional highlighting
vim.notify = nvim.notify

-- test if the override is working (should be colored blue)
-- vim.notify('init.lua loaded!', vim.log.levels.INFO, { title = 'Test Notification' })
nvim.info = function(msg, opts)
  vim.notify(msg, vim.log.levels.INFO, opts or {})
end

-- stylua: ignore start
_G.bt = function() Snacks.debug.backtrace() end
_G.ddd = function(...) return Snacks.debug.inspect(...) end
-- stylua: ignore end
vim.print = _G.ddd
-- ]]
-- Section: Plugins [[

-- TODO: Make this make sense
local Plug = require('nvim.plug')

Plug.do_configs({
  Plug('nvim.snacks'), -- must be first
  Plug('nvim.colorscheme'),
  Plug('nvim.diagnostic'),
  -- Plug('nvim.format'),
  -- Plug('nvim.lint'),
  Plug('nvim.lsp'),
  Plug('nvim.treesitter'),
})

require('plug')
-- ]]
-- Section: Keymaps [[

vim.keymap.set('n', '<leader>gg', function()
  Snacks.lazygit()
  vim.cmd.startinsert()
end, { desc = 'Lazygit' })

vim.keymap.set({ 'i', 'n', 's' }, '<Esc>', function()
  vim.cmd('noh')
  return '<Esc>'
end, { expr = true, desc = 'Escape and Clear hlsearch' })

-- stylua: ignore start
local function map_pickers(key, picker_opts, keymap_opts)
  vim.keymap.set('n', '<leader>f' .. key, function() Snacks.picker.files(picker_opts) end, keymap_opts)
  vim.keymap.set('n', '<leader>s' .. key, function() Snacks.picker.grep(picker_opts) end, keymap_opts)
end

map_pickers('c', {cwd=vim.fn.stdpath('config'), ft={'lua','vim'}}, {desc = 'Config Files'})
map_pickers('d', {cwd=vim.fn.stdpath('data')}, {desc = 'Data Files'})
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

-- `Snacks` Ex functions
command('Scratch', function(opts)
  if opts.bang == true then
    Snacks.scratch.select()
  else
    Snacks.scratch()
  end
end, { bang = true })

local function to_camel_case(str)
  return str
    :gsub('_%a', function(c)
      return c:sub(2):upper()
    end)
    :gsub('^%l', string.upper)
end

-- cache the original keys to skip
local skip = vim.tbl_keys(Snacks.picker)
skip[#skip + 1] = 'config' -- this one gets missed

-- also skip the lazy picker if we're not using lazy.nvim
if not package.loaded['lazy'] then
  skip[#skip + 1] = 'lazy'
end

-- HACK: force early loding of picker config
Snacks.picker.config.setup()

local pickers = vim.tbl_filter(function(name)
  return not vim.list_contains(skip, name)
end, vim.tbl_keys(Snacks.picker))

for _, name in ipairs(pickers) do
  local picker = Snacks.picker[name]
  local cmd = to_camel_case(name)
  if vim.fn.exists(':' .. cmd) ~= 2 then
    command(cmd, picker, { desc = 'Snacks Picker: ' .. cmd })
  end
end
-- ]]

-- vim:fdm=marker:fmr=[[,]]:fdl=0
