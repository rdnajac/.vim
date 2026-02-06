vim.cmd([[
  function! MyWinbar() abort
    return is#curwin() ? v:lua.nv.blink.status() : '%t'
  endfunction
]])
-- vim.schedule(function() vim.o.winbar = '%!MyWinbar()' end)
