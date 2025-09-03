return vim.defaulttable(function(k)
  return require('nvim.' .. k)
end)
