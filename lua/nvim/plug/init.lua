local M = {}

M.after = function() require('nvim.plug.api') end
M.build = require('nvim.plug.build')

-- TODO: build command to force rebuild of a plugin
vim.api.nvim_create_autocmd({ 'PackChanged' }, {
  callback = function(ev) require('nvim.plug.build')(ev) end,
})

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

return M
