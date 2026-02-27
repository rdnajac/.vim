-- TODO: build command to force rebuild of a plugin
vim.api.nvim_create_autocmd({ 'PackChanged' }, {
  callback = function(ev) require('nvim.plug.build')(ev) end,
})

return {
  load = require('nvim.plug.load'),
  spec = require('nvim.plug.spec'),
  specs = require('nvim.plug.core'),
  after = function() require('nvim.plug.api') end,
}
