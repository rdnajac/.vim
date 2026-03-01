local M = {}

-- TODO: build command to force rebuild of a plugin
vim.api.nvim_create_autocmd({ 'PackChanged' }, {
  callback = function(ev) require('nvim.plug.build')(ev) end,
})

M.spec = require('nvim.plug.spec')
M.after = function() require('nvim.plug.api') end
M.specs = {
  {
    'mason-org/mason.nvim',
    build = ':MasonUpdate',
    opts = { ui = { icons = require('nvim.ui.icons').mason.emojis } },
  },
  {
    'folke/lazydev.nvim',
    opts = {
      -- integrations = { cmp = false },
      library = {
        { path = 'snacks.nvim', words = { 'Snacks' } },
        { path = 'mini.nvim', words = { 'Mini.*' } },
        { path = 'nvim', words = { 'nv' } },
      },
    },
  },
}

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

  vim.cmd.packadd({ plug_data.spec.name, bang = vim.v.vim_did_enter == 0 })

  -- run setup for neovim plugins with `opts` tables
  maybe('setup')
end

return M
