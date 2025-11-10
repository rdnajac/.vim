-- TODO: this.
local tools = {
  'actionlint', -- code action linter
  'mmdc', -- mermaid diagrams
  'tree-sitter-cli',
}

local M = {}

---Install or update a Mason package.
---@param name_or_pkg string|table
M.install_or_update = function(name_or_pkg)
  local registry = require('mason-registry')
  local function setup_handlers(pkg)
    pkg
      :once('install:success', function(_pkg, _receipt)
        Snacks.notify.info(pkg.name .. ' installed')
      end)
      :once('install:failed', function(_pkg, err)
        Snacks.notify.error(pkg.name .. ' install failed: ' .. tostring(err))
      end)
  end
  local function do_install(pkg)
    if pkg:is_installed() then
      -- check for newer version
      local ok, latest = pcall(pkg.get_latest_version, pkg)
      if ok and latest and latest ~= pkg.version then
        Snacks.notify.warn('Updating ' .. pkg.name .. ' to ' .. latest)
        setup_handlers(pkg)
        pkg:install({ force = true }) -- force reinstallation/update
      else
        Snacks.notify.info(pkg.name .. ' already up to date')
      end
    else
      Snacks.notify.warn('Installing ' .. pkg.name)
      setup_handlers(pkg)
      pkg:install()
    end
  end

  -- If already a package object
  if type(name_or_pkg) == 'table' then
    return do_install(name_or_pkg)
  end

  local name = name_or_pkg
  registry.refresh(function()
    local ok, pkg = pcall(registry.get_package, name)
    if not ok or not pkg then
      Snacks.notify.error('Package not found: ' .. name)
      return
    end
    do_install(pkg)
  end)
end

local _ = require('mason-core.functional')
local registry = require('mason-registry')
local mappings = require('mason-lspconfig.mappings')
local settings = require('mason-lspconfig.settings')
local notify = require('mason-lspconfig.notify')

---@param lspconfig_server_name string
local function resolve_package(lspconfig_server_name)
  local Optional = require('mason-core.optional')
  local server_mapping = mappings('mason-lspconfig.mappings').get_mason_map()

  return Optional.of_nilable(server_mapping.lspconfig_to_package[lspconfig_server_name])
    :map(function(package_name)
      local ok, pkg = pcall(registry.get_package, package_name)
      if ok then
        return pkg
      end
    end)
end

M.ensure_installed = function()
  for _, server_identifier in ipairs(settings.current.ensure_installed) do
    local Package = require('mason-core.package')

    local server_name, version = Package.Parse(server_identifier)
    resolve_package(server_name)
      :if_present(
        ---@param pkg Package
        function(pkg)
          if not pkg:is_installed() and not pkg:is_installing() then
            require('mason-lspconfig.install').install(pkg, version)
          end
        end
      )
      :if_not_present(function()
        notify(
          ('[mason-lspconfig.nvim] Server %q is not a valid entry in ensure_installed. Make sure to only provide lspconfig server names.'):format(
            server_name
          ),
          vim.log.levels.WARN
        )
      end)
  end
end

local enabled_servers = {}

---@param mason_pkg string | Package
local function enable_server(mason_pkg)
  if type(mason_pkg) ~= 'string' then
    mason_pkg = mason_pkg.name
  end
  local lspconfig_name = mappings.get_mason_map().package_to_lspconfig[mason_pkg]
  if not lspconfig_name then
    return
  end
  if enabled_servers[lspconfig_name] then
    return
  end

  local automatic_enable = settings.current.automatic_enable

  if type(automatic_enable) == 'table' then
    local exclude = automatic_enable.exclude
    if exclude then
      if _.any(_.equals(lspconfig_name), exclude) then
        -- This server is explicitly excluded.
        return
      end
    else
      if not _.any(_.equals(lspconfig_name), automatic_enable) then
        -- This server is not explicitly enabled.
        return
      end
    end
  elseif automatic_enable == false then
    return
  end

  -- We don't provide LSP configurations in the lsp/ directory because it risks overriding configurations in a way the
  -- user doesn't want. Instead we only override LSP configurations for servers that are installed via Mason.
  local ok, config = pcall(require, ('mason-lspconfig.lsp.%s'):format(lspconfig_name))
  if ok then
    vim.lsp.config(lspconfig_name, config)
  end

  vim.lsp.enable(lspconfig_name)
  enabled_servers[lspconfig_name] = true
end

local enable_server_scheduled = vim.schedule_wrap(enable_server)

M.automatic_enable({
  init = function()
    enabled_servers = {}
    _.each(enable_server, registry.get_installed_package_names())
    -- We deregister the event handler primarily for testing purposes
    -- where `.setup()` is called multiple times in the same instance.
    registry:off('package:install:success', enable_server_scheduled)
    registry:on('package:install:success', enable_server_scheduled)
  end,
  enable_all = function()
    _.each(enable_server, registry.get_installed_package_names())
  end,
})

return M
