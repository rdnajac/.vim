function! comment#toggle() abort
  " vint: -ProhibitCommandRelyOnUser
  normal gcc
  " vint: +ProhibitCommandRelyOnUser
endfunction

function comment#syntax_match(...) abort
  let pos = a:0 ? a:1 : getpos('.')
  let synid = synID(pos[1], pos[2], 1)
  let name = synIDattr(synid, 'name')
  return !empty(name) && name =~# 'Comment'
endfunction

function! comment#insert(above, tag) abort
  execute 'normal!' .. (a:above ? 'O' : 'o') .. a:tag
  " TODO: check if format opts does not contain o instead
  " if !comment#syntax_match(getpos('.'))
  call comment#toggle()
  " endif
  normal! A
endfunction

" nmap <Plug>CommentAbove O<Esc>gccA<BS>
" nmap <Plug>CommentBelow o<Esc>gccA<BS>
" nmap coo <Plug>CommentBelow
" nmap coO <Plug>CommentAbove
