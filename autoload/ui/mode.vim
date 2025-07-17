function! ui#mode#line() abort
  return luaeval('require("util.lualine.components").mode()')
endfunction
