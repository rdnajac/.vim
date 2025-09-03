-- init.lua
_G.ddd = function(...)
  print(vim.inspect(...))
end
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0

vim.g.file_explorer = 'oil' ---@type 'netrw'|'snacks'|'oil'

-- disable netrw if using another file explorer
vim.g.loaded_netrw = vim.g.file_explorer == 'netrw' and 1 or nil

vim.loader.enable()

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

-- set these options first so it is apparent if vimrc overrides them
vim.o.cmdheight = 0
vim.o.laststatus = 3
vim.o.pumblend = 0
-- vim.o.smoothscroll = true
vim.o.winborder = 'rounded'
-- also try `:options`

local ok, extui = xpcall(require, debug.traceback, 'vim._extui')
if ok then
  extui.enable({})
end

local require = require('util').safe_require

_G.nv = require('nvim')

-- override vim.notify to provide additional highlighting
vim.notify = nv.notify

_G.info = function(t)
  vim.notify(vim.inspect(t), vim.log.levels.INFO)
end

vim.cmd.runtime('vimrc')

-- stylua: ignore start
_G.bt = function() Snacks.debug.backtrace() end
_G.ddd = function(...) return Snacks.debug.inspect(...) end
-- stylua: ignore end
vim.print = _G.ddd

-- test if the override is working (should be colored blue)
Snacks.notify.info('init.lua loaded!')

require('plug')

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

-- Supertab
vim.keymap.set('i', '<Tab>', function()
  local cmp = require('blink.cmp')
  local item = cmp.get_selected_item()
  local type = require('blink.cmp.types').CompletionItemKind

  -- TODO: what about snippet expansion?
  if not vim.lsp.inline_completion.get() then
    if cmp.is_visible() and item then
      cmp.accept()
      -- keep accepting path completions
      if item.kind == type.Path then
        vim.defer_fn(function()
          cmp.show({ providers = { 'path' } })
        end, 1)
      end
      return ''
    end
  end
  return '<Tab>'
end, { expr = true })
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
skip[#skip + 1] = 'keymap'

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

vim.api.nvim_create_user_command('PlugClean', function()
  vim.pack.del(vim.tbl_map(
    function(plugin)
      return plugin.spec.name
    end,
    vim.tbl_filter(function(plugin)
      return plugin.active == false
    end, vim.pack.get())
  ))
end, { desc = 'Remove unused plugins' })

vim.api.nvim_create_user_command('Plug', function(args)
  if #args.fargs == 0 then
    print(vim.inspect(vim.pack.get()))
  else
    vim.pack.add({ 'https://github.com/' .. args.fargs[1] })
  end
end, { nargs = '?', desc = 'Add a plugin' })

-- must pass nil to update all plugins with a bang
vim.api.nvim_create_user_command('PlugUpdate', function(opts)
  vim.pack.update(nil, { force = opts.bang })
end, { bang = true })

-- ]]

--- vim.diagnostic [[
---@type vim.diagnostic.Opts
local opts = {
  float = { source = true },
  underline = false,
  virtual_text = false,
  severity_sort = true,
  signs = { text = {}, numhl = {} },
}

-- set up the signs and highlights for each severity level
for name, severity in pairs(vim.diagnostic.severity) do
  -- capture the severity level as a number and ignore the short names
  if type(severity) == 'number' and #name > 1 then
    local diagnostic = name:sub(1, 1) .. name:sub(2):lower()
    opts.signs.text[severity] = nv.icons.diagnostics[diagnostic]
    opts.signs.numhl[severity] = 'Diagnostic' .. diagnostic
  end
end

vim.diagnostic.config(opts)
-- ]]

-- vim:fdm=marker:fmr=[[,]]:fdl=0
