-- init.lua
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

_G.ddd = function(...)
  print(vim.inspect(...))
end

require('util').safe_require('vim._extui').enable({})

_G.nv = require('nvim')

vim.notify = nv.notify
_G.info = function(t)
  vim.notify(vim.inspect(t), vim.log.levels.INFO)
end
vim.print = info

nv.mods_on_init = mods
nv.did_setup = {}

vim.cmd([[runtime vimrc]])

local pluglist = vim.g['plug#list']

nv.specs = vim.tbl_map(function(p)
  return vim.endswith(p, '.nvim') and nv.plug.spec(p) or p
end, pluglist)

-- FIXME:
for _, mod in ipairs({ 'blink.cmp', 'treesitter', 'lsp' }) do
  vim.list_extend(nv.specs, nv.plug(mod))
end

vim.pack.add(nv.specs, {
  confirm = vim.v.vim_did_enter == 1, -- don't confirm during startup
  load = function(data)
    local spec = data.spec
    local plugin = spec.name
    local bang = vim.v.vim_did_enter == 0

    vim.cmd.packadd({ plugin, bang = bang, magic = { file = false } })

    if not spec.data then
      return
    end

    if spec.data and vim.is_callable(spec.data.setup) then
      spec.data.setup()
    end

    -- do setup
    -- TODO: use spec object
    if vim.is_callable(spec.data.config) then
      spec.data.config()
      info('configured ' .. plugin .. '!')
      table.insert(nv.did_setup, plugin)
    elseif type(spec.data.opts) == 'table' then
      require(plugin).setup(spec.data.opts)
      info('setup ' .. plugin .. '!')
      table.insert(nv.did_setup, plugin)
    end
  end,
})

vim.cmd([[packadd vimline.nvim]])

nv.plug.after('oil')
