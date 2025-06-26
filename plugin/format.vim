function! s:MyFormatExpr() abort
  let l:start = v:lnum
  let l:end = v:lnum + v:count - 1
  let l:lines = getline(l:start, l:end)

  if empty(&formatprg)
    call s:equalprg()
    return 0
  else
    echom 'Using formatprg: ' . &formatprg
  endif

  " Run formatprg on those lines via stdin
  let l:cmd = expandcmd(&formatprg)
  let l:output = systemlist(l:cmd, l:lines)

  if v:shell_error || empty(l:output)
    echohl WarningMsg |
    echom 'Formatter failed or returned nothing'
    echohl None
    return v:shell_error ? v:shell_error : 1
  elseif l:output !=# l:lines
    let l:view = winsaveview()
    execute l:start . ',' . l:end . 'delete _'
    " undojoin | call append(l:start - 1, l:output)
    call append(l:start - 1, l:output)
    call winrestview(l:view)
  endif

  return 0
endfunction

set formatexpr=MyFormatExpr()
" FIXME:
" set formatexpr=format#expr()

function! format#expr() abort
  let l:start = v:lnum
  let l:end = v:lnum + v:count - 1
  let l:lines = getline(l:start, l:end)

  if empty(&formatprg)
    call s:equalprg()
    return 0
  else
    echom 'Using formatprg: ' . &formatprg
  endif

  " Run formatprg on those lines via stdin
  let l:cmd = expandcmd(&formatprg)
  let l:output = systemlist(l:cmd, l:lines)

  if v:shell_error || empty(l:output)
    echohl WarningMsg |
    echom 'Formatter failed or returned nothing'
    echohl None
    return v:shell_error ? v:shell_error : 1
  elseif l:output !=# l:lines
    let l:view = winsaveview()
    execute l:start . ',' . l:end . 'delete _'
    " undojoin | call append(l:start - 1, l:output)
    call append(l:start - 1, l:output)
    call winrestview(l:view)
  endif

  return 0
endfunction

function! format#buffer() abort
  let l:view = winsaveview()

  try
    if empty(&formatprg)
      call s:equalprg()
    else
      normal gggqG
      " keepjumps normal! gggqG
      " BUG: someitmes a newline is added
      call s:strip_trailing_newlines()
    endif
  catch /^Vim\%((\a\+)\)\=:E/
    echohl ErrorMsg | echom 'Formatting failed: ' . v:exception | echohl None
  finally
    call winrestview(l:view)
  endtry
endfunction
" function! GQ(type, ...)
"   normal! '[v']gq
"   call winrestview(w:gqview)
"   unlet w:gqview
" endfunction
" nmap <silent> gq :let w:gqview = winsaveview()<CR>:set opfunc=GQ<CR>g@

" augroup AutoFormat
"   autocmd!
"   autocmd BufWritePre *.lua,*.sh,*.vim if &modified | silent call format#buffer() | endif
" augroup END
