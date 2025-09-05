function test_modnames()
  local plugins = { 'user/repo', 'nvim/repo', 'user/repo.nvim' }

  for _, plugin in ipairs(plugins) do
    local plugname = vim.endswith(plugin, '.nvim')
        and 'nvim.' .. plugin:match('([^/]+)$'):gsub('%.nvim$', '')
      or plugin

    print('plugin =', plugin, '-> plugname =', plugname)
  end
end

test_modnames()

-- local Plugin = require('plug._spec')('user/repo')
local Plugin = require('plug._spec')(require('nvim.dial'))
info(Plugin:spec().data())
