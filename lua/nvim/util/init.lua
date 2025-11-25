return vim.defaulttable(function(k)
  return require('nvim.util.' .. k)
end)
