function! ui#mode#line() abort
  return luaeval('require("util.lualine").mode()')
endfunction
