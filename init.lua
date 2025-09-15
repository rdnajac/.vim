-- init.lua
-- vim._print(true, vim.tbl_keys(package.loaded))
_G.t0 = vim.uv.hrtime() -- capture the start time

-- randomly enable loader for benchmarking
if vim.uv.random(1):byte(1) % 2 == 1 then
  vim.loader.enable()
end

--- @type table
_G.nv = require('nvim') or {}

_G.info = function(...)
  vim.notify(vim.inspect(...), vim.log.levels.INFO)
end

-- optionally, override vim.notify
-- nv.notify.setup()

vim.cmd([[runtime vimrc]])

-- TODO: turn these into plugins
for _, modname in ipairs({ 'copilot', 'diagnostic', 'lsp', 'treesitter', 'ui' }) do
  -- local module = require('nvim.' .. modname)
  local module = nv[modname]
  local specs = module.specs or { module[1] } or {}

  if vim.islist(specs) and #specs > 0 then
    nv.plug(vim.tbl_map(nv.plug.to_spec, specs))
  end

  if vim.is_callable(module.setup) then
    -- TODO: load on vim enter
    module.setup()
    table.insert(nv.did_setup, modname)
  end
end

require('nvim.util.startuptime')
