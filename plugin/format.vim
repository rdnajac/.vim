function! MyFormatExpr() abort
  let start = v:lnum
  let end = v:lnum + v:count - 1
  " let view = winsaveview()
  if empty(&formatprg)
    " NOTE: this work on the entire buffer, not just the range
    normal! gg=G
    retab
    %s/\s\+$//e
    %s/\n\+\%$//e
  else
    let lines = getline(start, end)
    let output = systemlist(expandcmd(&formatprg), lines)
    if !v:shell_error
      call setline(start, output)
    endif
  endif
  " %s/\n\+\%$//e
  " call winrestview(view)
  return 0
endfunction

set formatexpr=MyFormatExpr()

function! GQ(type, ...)
  normal! '[v']gq
  call winrestview(w:gqview)
  unlet w:gqview
endfunction
nmap <silent> gq :let w:gqview = winsaveview()<CR>:set opfunc=GQ<CR>g@

" augroup AutoFormat
"   autocmd!
"   autocmd BufWritePre *.lua,*.sh,*.vim if &modified | silent call format#buffer() | endif
" augroup END
