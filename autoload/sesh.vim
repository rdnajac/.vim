function! s:sesh() abort
  return getcwd() . '/Session.vim'
endfunction

function! sesh#restore() abort
  if argc() == 0 && filereadable(s:sesh())
    execute 'silent! source ' . fnameescape(s:sesh())
    " FIXME: does this work?
    call delete(s:sesh())
  endif
endfunction
