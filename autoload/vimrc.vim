" let g:vimrc#dir = split(&runtimepath, ',')[0]
let g:vimrc#dir = fnamemodify($MYVIMRC, ':h')
let $VIMDIR = g:vimrc#dir

function! vimrc#init() abort
  if !has('nvim')
    call vim#defaults#()
    call vim#sensible#()
  else
    let g:loaded_node_provider = 0
    let g:loaded_perl_provider = 0
    let g:loaded_python3_provider = 0
    let g:loaded_ruby_provider = 0
  endif
endfunction

function! vimrc#setmark(pattern, idx, line) abort
  let char = matchstr(a:line, a:pattern . '\zs.')
  if empty (char) | return | endif
  " echom 'Setting mark ' . char . ' at line ' . a:idx
  " if !has('nvim')
  call setpos("'" . toupper(char), [0, a:idx + 1, 1, 0])
  " else
  " call nvim_buf_set_mark(bufnr('%'), char, a:idx + 1, 1, 0)
  " endif
endfunction

function! vimrc#setmarks() abort
  call map(getline(1, '$'), {i, line -> vimrc#setmark('augroup\ vimrc\.', i, line)})
endfunction

