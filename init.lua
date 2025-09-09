-- init.lua
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.file_explorer = 'oil' ---@type 'netrw'|'snacks'|'oil'
vim.g.loaded_netrw = vim.g.file_explorer ~= 'netrw' and 1 or nil

vim.loader.enable()

-- ui options [[
-- set these options first so it is apparent if vimrc overrides them
vim.o.cmdheight = 0
vim.o.laststatus = 3
vim.o.pumblend = 0
-- vim.o.smoothscroll = true
vim.o.winborder = 'rounded'
-- also try `:options`

require('util').safe_require('vim._extui').enable({})
-- ]]

-- print and notify [[
_G.ddd = function(...)
  print(vim.inspect(...))
end

_G.nv = require('nvim')

vim.notify = nv.notify
_G.info = function(...)
  vim.notify(vim.inspect(...), vim.log.levels.INFO)
end
vim.print = info
-- ]]

vim.cmd([[runtime vimrc]])

nv.specs = vim.tbl_map(function(p)
  return nv.plug[vim.endswith(p, '.nvim') and 'spec' or 'gh'](p)
end, vim.g['plug#list'])

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

    if spec.data then
      -- TODO: use spec object?
      if vim.is_callable(spec.data.config) then
        spec.data.config()
        -- info('configured ' .. plugin .. '!')
        table.insert(nv.did_setup, plugin)
      elseif type(spec.data.opts) == 'table' then
        require(plugin).setup(spec.data.opts)
        -- info('setup ' .. plugin .. '!')
        table.insert(nv.did_setup, plugin)
      end
    end
  end,
})

vim.cmd([[packadd vimline.nvim]])

nv.plug.after('oil')
nv.plug.after('render-markdown')
-- vim:fdm=marker:fmr=[[,]]:fdl=0
