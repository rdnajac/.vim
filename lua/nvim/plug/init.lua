local M = {}

M.build = require('nvim.plug.build')

---@param plug_data { spec: vim.pack.Spec, path: string }
M.load = function(plug_data)
  ---@param key string
  local maybe = function(key)
    local fn = vim.tbl_get(plug_data.spec, 'data', key)
    if vim.is_callable(fn) then
      fn()
    end
  end
  -- run init for vim plugins or `package.preload` hijinks
  maybe('init')

  -- always `packadd`! since we guard against `vim_did_enter`
  vim.cmd.packadd({ plug_data.spec.name, bang = true })

  -- run setup for neovim plugins with `opts` tables
  maybe('setup')
end

M.spec = require('nvim.plug.spec')
M.specs = require('nvim.plug.core')
M.after = function() require('nvim.plug.api') end

-- TODO: build command to force rebuild of a plugin
vim.api.nvim_create_autocmd({ 'PackChanged' }, {
  callback = function(ev) M.build(ev) end,
})

return M
