local t0 = vim.uv.hrtime() -- capture the start time

vim.loader.enable()

_G.nv = require('nvim')
-- _G.nv = vim.defaulttable(function(k)
--   return require('nvim.' .. k)
-- end)

_G.info = function(...)
  vim.notify(vim.inspect(...), vim.log.levels.INFO)
end
-- nv.notify.setup() -- optionally, override vim.notify
vim.cmd.runtime([[vimrc]])

-- TODO: turn these into plugins
for _, modname in ipairs({ 'copilot', 'diagnostic', 'lsp', 'treesitter', 'ui' }) do
  local module = nv[modname]
  local specs = module.specs or { module[1] } or {}

  if vim.islist(specs) and #specs > 0 then
    nv.plug(vim.tbl_map(nv.plug.to_spec, specs))
  end

  if vim.is_callable(module.config) then
    module.config() -- TODO: load on vim enter
    table.insert(nv.did_setup, modname)
  end

  if module.after and vim.is_callable(module.after) then
    module.after()
  end

  local keys
  if module.keys then
    if vim.is_callable(module.keys) then
      keys = module.keys()
    else
      keys = module.keys
    end
    if keys and vim.islist(keys) and #keys > 0 then
      require('which-key').add(keys)
    end
  end
end

_G.startuptime = (vim.uv.hrtime() - t0) / 1e6
print(('nvim initialized in %.2f ms'):format(startuptime))
-- require('nvim.util.startuptime')

vim.g.health = { style = 'float' }
-- disable external providers to silence checkhealth warnings
for _, provider in ipairs({ 'node', 'perl', 'ruby' }) do
  vim.g[provider] = 0
end

---@type 'netrw'|'snacks'|'oil'
vim.g.file_explorer = 'oil'
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
