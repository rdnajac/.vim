local M = {}

-- TODO: do we have to cache this ourselves?
-- or does mason do this internally?
M.reg = require('mason-registry')

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
    local ok, pkg = pcall(M.reg.get_package, name)
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
  local pkgs = M.reg.get_all_packages()
  local names = {}
  for _, pkg in ipairs(pkgs) do
    if pkg:is_installed() then
      table.insert(names, pkg.name)
    end
  end
  return names
end

M.mason_map = function()
  local _ = require('mason-core.functional')

  -- Cache the package specs
  local cached_specs = _.lazy(M.reg.get_all_package_specs)
  M.reg:on('update:success', function()
    cached_specs = _.lazy(M.reg.get_all_package_specs)
  end)

  -- Build mappings
  local mason_map = {}
  for _, pkg_spec in ipairs(cached_specs()) do
    local lspconfig = vim.tbl_get(pkg_spec, 'neovim', 'lspconfig')
    if lspconfig then
      mason_map[lspconfig] = pkg_spec.name
    end
  end

  return mason_map
end

M.ensure_installed = function()
  local map = M.mappings()
  local servers = {}

  for _, server in ipairs(require('nvim.lsp').servers) do
    local mason_name = map[server]
    if mason_name then
      table.insert(servers, mason_name)
    end
  end

  return servers
end

-- TODO:
-- M.update = function()
--
-- end


return M
