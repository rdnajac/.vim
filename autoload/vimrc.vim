" let g:vimrc#dir = split(&runtimepath, ',')[0]
let g:vimrc#dir = fnamemodify($MYVIMRC, ':h')

function! vimrc#now() abort
  let total = reltimefloat(reltime())
  let totalsec = float2nr(total)
  let ms = float2nr((total - totalsec) * 1000)
  return strftime("%H:%M:%S", totalsec) . printf(".%03d", ms)
endfunction
"
" ia <expr> dt strftime('%Y-%m-%d')
" ia <expr> tm strftime('%H:%M:%S')
" ia <expr> dtm strftime('%Y-%m-%d %H:%M:%S')
" ia LR LAST REVISION: <C-R>=strftime('%Y-%m-%d')<CR>

function! vimrc#setmark(pattern, idx, line) abort
  let char = matchstr(a:line, a:pattern . '\zs.')
  if !empty (char)
    call setpos("'" . toupper(char), [0, a:idx + 1, 1, 0])
  endif
endfunction

function! vimrc#setmarks() abort
  call map(getline(1, '$'), {i, line -> vimrc#setmark('augroup\ vimrc\.', i, line)})
endfunction
