return vim.defaulttable(function(k)
  -- return require(vim.fs.basename(vim.fs.dirname(debug.getinfo(1, 'S').source:sub(2))) .. '.' .. k)
  return require('nvim.' .. k)
end)
