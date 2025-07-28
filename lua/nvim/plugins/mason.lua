local M = { 'mason-org/mason.nvim' }

-- FIXME:
M.tools = {}

function M.install()
  local reg = require('mason-registry')
  local total = #M.tools
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

  for _, name in ipairs(M.tools) do
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
  local reg = require('mason-registry')
  local pkgs = reg.get_all_packages()
  local names = {}
  for _, pkg in ipairs(pkgs) do
    if pkg:is_installed() then
      table.insert(names, pkg.name)
    end
  end
  return names
end

M.config = function()
  require('mason').setup({})
end

return M
