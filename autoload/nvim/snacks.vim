" autoload/nvim/snacks.vim
" safely call a snack function from vimscripT
" autoload/nvim/snacks.vim
function! nvim#snacks#(snack, ...) abort
  if has('nvim') && luaeval("_G.Snacks ~= nil or package.loaded['Snacks'] ~= nil")
    if a:0
      call luaeval('Snacks[_A[1]](_A[2])', [a:snack, a:1])
    else
      call luaeval('Snacks[_A]()', a:snack)
    endif
  else
    call vim#notify#('no Snacks...')
  endif
endfunction
