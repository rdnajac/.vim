local M = { 'mason-org/mason.nvim' }

-- FIXME:
M.tools = {}

M.install = function()
  -- FIXME:
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
      if pkg:is_installed() then
        done()
        goto continue
      end

      Snacks.notify.warn('Installing ' .. tool)

      pkg:once('install:success', function()
        Snacks.notify.info(tool .. ' installed successfully')
        done()
      end)
      pkg:once('install:failed', function()
        Snacks.notify.error(tool .. ' installation failed')
        done()
      end)

      pkg:install()
    end
    ::continue::
  end
end

M.config = function()
  require('mason').setup({})
  -- TODO:
end

return M
