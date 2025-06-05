_G.bt = function()
  Snacks.debug.backtrace()
end
_G.dd = function(...)
  Snacks.debug.inspect(...)
end
vim.print = _G.dd -- Override print to use snacks for `:=` command

require('munchies.spinner')
