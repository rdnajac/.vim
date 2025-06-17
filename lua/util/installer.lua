local M = {}

function M.mason_install()
  local tools = lang_spec.tools
  local total = #tools
  local completed = 0

  local function done()
    completed = completed + 1
    if completed == total then
      Snacks.notify.info('All tools checked.')
    end
  end

  for _, tool in ipairs(tools) do
    local ok, pkg = pcall(require('mason-registry').get_package, tool)
    if not ok then
      Snacks.notify.error('Tool not found in mason registry: ' .. tool)
      done()
    else
      local is_update = false
      if not pkg:is_installed() then
        Snacks.notify.warn('Installing ' .. tool)
      else
        local current = pkg:get_installed_version()
        local latest = pkg:get_latest_version()
        if current == latest then
          done()
          goto continue
        end
        Snacks.notify.warn('Updating ' .. tool)
        is_update = true
      end

      pkg:once('install:success', function()
        Snacks.notify.info(tool .. (is_update and ' updated successfully' or ' installed successfully'))
        done()
      end)
      pkg:once('install:failed', function()
        Snacks.notify.error(tool .. (is_update and ' update failed' or ' installation failed'))
        done()
      end)

      if is_update then
        pkg:install({ version = pkg:get_latest_version() })
      else
        pkg:install()
      end
    end
    ::continue::
  end
end

return M
