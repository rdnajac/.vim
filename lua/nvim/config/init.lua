-- automagically load plugin modules in this directory
vim.defer_fn(function()
  require('meta').module()
end, 0)
