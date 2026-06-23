function! s:toggle_comment() abort
  " vint: -ProhibitCommandRelyOnUser
  normal gcc
  " vint: +ProhibitCommandRelyOnUser
endfunction

function! comment#insert(above, tag) abort
  execute 'normal!' .. (a:above ? 'O' : 'o') .. a:tag
  if !is#comment(getpos('.'))
    call comment#toggle()
  endif
  normal! A
endfunction

" nmap <Plug>CommentAbove O<Esc>gccA<BS>
" nmap <Plug>CommentBelow o<Esc>gccA<BS>
" nmap coo <Plug>CommentBelow
" nmap coO <Plug>CommentAbove
