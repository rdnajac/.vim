" TODO: integrate with keywordprg.vim
function! keymap#gf#() abort
  if &filetype ==# 'msg' || &filetype ==# 'pager'
    return ''
  endif
  " if there is a line number at the end of the uri,
  " use `gF` to open it and jump to the line number
  return expand('<cWORD>') =~# ':\d\+$' ? 'gF' : 'gf'
endif
endfunction
