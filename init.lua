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
  local module = nv[modname]
  local specs = module.specs or { module[1] } or {}

  if vim.islist(specs) and #specs > 0 then
    nv.plug(vim.tbl_map(nv.plug.to_spec, specs))
  end

  if vim.is_callable(module.config) then
    module.config() -- TODO: load on vim enter
    table.insert(nv.did_setup, modname)
  end
end

_G.startuptime = (vim.uv.hrtime() - _G.t0) / 1e6
-- TODO: util func to wrap around a function to measure time
print(('nvim initialized in %.2f ms'):format(startuptime))
-- local flash_keys = nv.flash.keys
-- info(flash_keys)
nv.map = require('which-key').add
nv.map(nv.flash.keys)

vim.call('vimline#tabline#')
-- require('nvim.util.startuptime')
