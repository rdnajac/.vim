function! s:setmark(pattern, idx, line) abort
  let char = matchstr(a:line, a:pattern . '\zs.')
  if !empty (char)
    call setpos("'" . toupper(char), [0, a:idx + 1, 1, 0])
  endif
endfunction

" create marks for each augroup to jump to specific vimrc lines from anywhere
function! vimrc#_set_global_marks() abort
  call map(getline(1, '$'), {i, line -> s:setmark('augroup\ vimrc\.', i, line)})
endfunction
