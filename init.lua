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

-- filter only modules under config
local mods = vim.tbl_filter(function(m)
  return m.modpath:find(vim.fn.stdpath('config'), 1, true) == 1
end, vim.loader.find('*', { all = true }))

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

local require = require('util').safe_require

require('vim._extui').enable({})

_G.nv = require('nvim')

-- override vim.notify to provide additional highlighting
vim.notify = nv.notify

_G.info = function(t)
  vim.notify(vim.inspect(t), vim.log.levels.INFO)
end

-- vim.print = Snacks and Snacks.debug.inspect or info
vim.print = info

vim.cmd.runtime('vimrc')

vim.schedule(function()
  require('keymaps')
  require('nvim.lsp')
  require('nvim.treesitter')
  require('diagnostic')
  require('commands')
end)
