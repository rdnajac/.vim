-- https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim
local mr = require('mason-registry')
local SETTINGS = {
  ensure_installed = {},
  auto_update = false,
  run_on_start = true,
  start_delay = 0,
}

local show = vim.schedule_wrap(function(msg)
  Snacks.notify.info(msg, { title = 'mason-tool-installer' })
end)

local show_error = vim.schedule_wrap(function(msg)
  Snacks.notify.error(msg, { title = 'mason-tool-installer' })
end)

local installed = false
local installed_packages = {}

local do_install = function(p, version, on_close)
  if version ~= nil then
    show(string.format('%s: updating to %s', p.name, version))
  else
    show(string.format('%s: installing', p.name))
  end
  p:once('install:success', function()
    show(string.format('%s: successfully installed', p.name))
  end)
  p:once('install:failed', function()
    show_error(string.format('%s: failed to install', p.name))
  end)
  if not installed then
    installed = true
    vim.schedule(function()
      vim.api.nvim_exec_autocmds('User', {
        pattern = 'MasonToolsStartingInstall',
      })
    end)
  end
  table.insert(installed_packages, p.name)
  if not p:is_installing() then
    p:install({ version = version }, vim.schedule_wrap(on_close))
  end
end

local check_install = function(force_update, sync)
  sync = sync or false
  if not force_update then
    return
  end
  installed = false -- reset for triggered events
  installed_packages = {} -- reset
  local completed = 0
  local total = vim.tbl_count(SETTINGS.ensure_installed)
  local all_completed = false
  local on_close = function()
    completed = completed + 1
    if completed >= total then
      local event = {
        pattern = 'MasonToolsUpdateCompleted',
      }
      event.data = installed_packages
      vim.api.nvim_exec_autocmds('User', event)
      all_completed = true
    end
  end
  local ensure_installed = function()
    for _, item in ipairs(SETTINGS.ensure_installed or {}) do
      local name, version, auto_update, condition
      if type(item) == 'table' then
        name = item[1]
        version = item.version
        auto_update = item.auto_update
        condition = item.condition
      else
        name = item
      end
      if condition ~= nil and not condition() then
        vim.schedule(on_close)
      else
        local p = mr.get_package(name)
        if p:is_installed() then
          if version ~= nil then
            local installed_version = p:get_installed_version()
            if installed_version ~= version then
              do_install(p, version, on_close)
            else
              vim.schedule(on_close)
            end
          elseif
            force_update or (force_update == nil and (auto_update or (auto_update == nil and SETTINGS.auto_update)))
          then
            local latest_version = p:get_latest_version()
            local installed_version = p:get_installed_version()
            if latest_version ~= installed_version then
              do_install(p, latest_version, on_close)
            else
              vim.schedule(on_close)
            end
          else
            vim.schedule(on_close)
          end
        else
          local p = mr.get_package(name)
          if p:is_installed() then
            if version ~= nil then
              p:get_installed_version(function(ok, installed_version)
                if ok and installed_version ~= version then
                  do_install(p, version, on_close)
                else
                  vim.schedule(on_close)
                end
              end)
            elseif
              force_update or (force_update == nil and (auto_update or (auto_update == nil and SETTINGS.auto_update)))
            then
              p:check_new_version(function(ok, version)
                if ok then
                  do_install(p, version.latest_version, on_close)
                else
                  vim.schedule(on_close)
                end
              end)
            else
              vim.schedule(on_close)
            end
          else
            do_install(p, version, on_close)
          end
        end
      end
    end
  end
  if mr.refresh then
    mr.refresh(ensure_installed)
  else
    ensure_installed()
  end
  if sync then
    while true do
      vim.wait(10000, function()
        return all_completed
      end)
      if all_completed then
        break
      end
    end
  end
end

local run_on_start = function()
  if SETTINGS.run_on_start then
    vim.defer_fn(check_install, SETTINGS.start_delay or 0)
  end
end

local clean = function()
  local expected = {}
  for _, item in ipairs(SETTINGS.ensure_installed or {}) do
    local name
    if type(item) == 'table' then
      name = item[1]
    else
      name = item
    end
    table.insert(expected, name)
  end

  local all = mr.get_all_package_names()
  for _, name in ipairs(all) do
    if mr.is_installed(name) and not vim.tbl_contains(expected, name) then
      vim.notify(string.format('Uninstalling %s', name), vim.log.levels.INFO, { title = 'mason-tool-installer' })
      mr.get_package(name):uninstall()
    end
  end
end

return {
  run_on_start = run_on_start,
  check_install = check_install,
  setup = setup,
  clean = clean,
}
