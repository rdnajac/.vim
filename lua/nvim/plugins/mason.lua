local M = {
  'mason-org/mason.nvim',
  opts = { ui = { icons = nv.icons.mason } },
  build = ':MasonUpdate',
}

-- stylua: ignore start
--- Get the Mason registry module
--- @return table Mason registry module
M.reg = function() return require('mason-registry') end

--- Get list of installed package names
--- @return string[] List of installed package names
M.installed = function() return M.reg().get_installed_package_names() end
-- stylua: ignore end

--- Install a Mason package by name or package object
--- @param name_or_pkg string|table Package name (string) or package object (table)
M.install = function(name_or_pkg)
  local reg = M.reg()
  
  -- Handle package object directly
  if type(name_or_pkg) == 'table' then
    local pkg = name_or_pkg
    if not pkg:is_installed() then
      pkg:once('install:success', function()
        Snacks.notify.info(pkg.name .. ' installed')
      end)
      pkg:once('install:failed', function()
        Snacks.notify.error(pkg.name .. ' failed to install')
      end)
      pkg:install()
    end
    return
  end
  
  -- Handle package name (string)
  local name = name_or_pkg
  reg.refresh(function()
    local ok, pkg = pcall(reg.get_package, name)
    if not ok then
      Snacks.notify.error('Package not found: ' .. name)
      return
    end
    
    if pkg:is_installed() then
      Snacks.notify.info(name .. ' is already installed')
    else
      Snacks.notify.warn('Installing ' .. name)
      pkg:once('install:success', function()
        Snacks.notify.info(name .. ' installed')
      end)
      pkg:once('install:failed', function()
        Snacks.notify.error(name .. ' failed to install')
      end)
      pkg:install()
    end
  end)
end

return M
