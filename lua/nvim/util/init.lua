_G.sprintf = function(s, ...)
  return s:format(...)
end

return vim.defaulttable(function(k)
  return require('nvim.util.' .. k)
end)
