local M = { 'mason-org/mason.nvim', opts = {} }

-- TODO: do we have to cache this ourselves?
-- or does mason do this internally?
M.reg = function()
  return require('mason-registry')
end

function M.install(tools)
  local total = #tools
  if total == 0 then
    return
  end

  local done = 0
  local function tick()
    done = done + 1
    if done == total then
      Snacks.notify.info('All tools checked.')
    end
  end

  for _, name in ipairs(tools) do
    local reg = M.reg()
    local ok, pkg = pcall(reg.get_package, name)
    if not ok then
      Snacks.notify.error('Tool not found: ' .. name)
      tick()
    else
      if pkg:is_installed() then
        tick()
      else
        Snacks.notify.warn('Installing ' .. name)
        pkg:once('install:success', function()
          Snacks.notify.info(name .. ' installed')
          tick()
        end)
        pkg:once('install:failed', function()
          Snacks.notify.error(name .. ' failed')
          tick()
        end)
        pkg:install()
      end
    end
  end
end

M.list = function()
  return vim.tbl_map(
    function(pkg)
      return pkg.name
    end,
    vim.tbl_filter(function(pkg)
      return pkg:is_installed()
    end, require('mason-registry').get_all_packages())
  )
end

M.map = function()
  local _ = require('mason-core.functional')

  -- Cache the package specs
  -- TODO:DRY?
  local cached_specs = _.lazy(M.reg.get_all_package_specs)

  M.reg:on('update:success', function()
    cached_specs = _.lazy(M.reg.get_all_package_specs)
  end)

  local mason_map = {}

  -- TODO:use tbl func?
  for _, pkg_spec in ipairs(cached_specs()) do
    local lspconfig = vim.tbl_get(pkg_spec, 'neovim', 'lspconfig')
    if lspconfig then
      mason_map[lspconfig] = pkg_spec.name
    end
  end

  return mason_map
end

M.ensure_installed = function()
  local map = M.map()

  return vim.tbl_map(
    function(server)
      return map[server]
    end,
    vim.tbl_filter(function(server)
      return map[server] ~= nil
    end, require('nvim.lsp').servers)
  )
end

M.update = function()
  M.install(M.ensure_installed())
  -- TODO: update all?
  -- TODO: build hook on update
end

return M
