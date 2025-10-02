-- TODO: this.
local M = {
  'mason-org/mason.nvim',
  opts = { ui = { icons = nv.icons.mason } },
  build = ':MasonUpdate',
}
--- commands for the mason-registry
local api = {
  'get_all_packages',
  'get_installed_packages',
  'has_package',
  'get_package',
  'get_all_package_specs',
  'get_installed_package_names',
  'get_all_package_names',
  'update',
  'aliases',
  'is_installed',
  'sources',
  'refresh',
  'get_package_aliases',
  'register_package_aliases',
}

local also_install = { 'tree-sitter-cli' }

-- local example = function()
--   registry.refresh(function()
--     local packages = registry.get_all_packages()
--     -- ...
--   end)
-- end

-- stylua: ignore start
M.reg = function() return require('mason-registry') end
M.installed = function() return M.reg().get_installed_package_names() end
-- stylua: ignore end

-- M.install('a')
-- if 1 then return end
--   local total = #tools
--   if total == 0 then
--     return
--   end
--
--   local done = 0
--   local function tick()
--     done = done + 1
--     if done == total then
--       Snacks.notify.info('All tools checked.')
--     end
--   end
--
--   for _, name in ipairs(tools) do
--     local reg = M.reg()
--     local ok, pkg = pcall(reg.get_package, name)
--     if not ok then
--       Snacks.notify.error('Tool not found: ' .. name)
--       tick()
--     else
--       if pkg:is_installed() then
--         tick()
--       else
--         Snacks.notify.warn('Installing ' .. name)
--         pkg:once('install:success', function()
--           Snacks.notify.info(name .. ' installed')
--           tick()
--         end)
--         pkg:once('install:failed', function()
--           Snacks.notify.error(name .. ' failed')
--           tick()
--         end)
--         pkg:install()
--       end
--     end
--   end
-- end

-- M.map = function()
--   local _ = require('mason-core.functional')
--
--   -- Cache the package specs
--   -- TODO:DRY?
--   local cached_specs = _.lazy(M.reg.get_all_package_specs)
--
--   M.reg:on('update:success', function()
--     cached_specs = _.lazy(M.reg.get_all_package_specs)
--   end)
--
--   local mason_map = {}
--
--   -- TODO:use tbl func?
--   for _, pkg_spec in ipairs(cached_specs()) do
--     local lspconfig = vim.tbl_get(pkg_spec, 'neovim', 'lspconfig')
--     if lspconfig then
--       mason_map[lspconfig] = pkg_spec.name
--     end
--   end
--
--   return mason_map
-- end

-- M.ensure_installed = function()
--   local map = M.map()
--
--   return vim.tbl_map(
--     function(server)
--       return map[server]
--     end,
--     vim.tbl_filter(function(server)
--       return map[server] ~= nil
--     end, require('nvim.lsp').servers)
--   )
-- end
--
-- -- TODO:
-- -- M.ensure_installed_transformed() = vim.tbl_map(

return M
