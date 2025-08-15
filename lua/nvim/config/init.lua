-- automagically load plugin modules in this directory
vim.defer_fn(function()
  require('util.meta').module()
end, 0)
