-- TODO: this.
local tools = {
  'actionlint', -- code action linter
  'mmdc', -- mermaid diagrams
  'tree-sitter-cli'
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

return M
