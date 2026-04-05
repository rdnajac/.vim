nmap vv gcc
nmap dc dgc
nmap yc ygc

" comment out a line and paste it below
nmap gy "xyygcc"xp

" start a comment above or below the current line
nmap coO O0<Esc>gccA<BS>
nmap coo o0<Esc>gccA<BS>
" nmap <Plug>CommentAbove O<Esc>gccA<BS>
" nmap <Plug>CommentBelow o<Esc>gccA<BS>
" nmap coo <Plug>CommentBelow
" nmap coO <Plug>CommentAbove

function! s:toggle_comment() abort
  " vint: -ProhibitCommandRelyOnUser
  normal gcc
  " vint: +ProhibitCommandRelyOnUser
endfunction

function! s:title() abort
  execute append(0, substitute(fnamemodify(expand('%'), ':p'), git#root()..'/', '', ''))
  call s:toggle_comment()
endfunction

nnoremap <leader>fn <Cmd>call <SID>title()<CR>

let s:comments = {
      \ 'b': 'BUG: ',
      \ 'f': 'FIXME: ',
      \ 'h': 'HACK: ',
      \ 'w': 'WARN: ',
      \ 'n': 'NOTE: ',
      \ 't': 'TODO: ',
      \ 'x': 'XXX: ',
      \ 'i': 'stylua: ignore',
      \ }

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
  call s:toggle_comment()
  " endif
  normal! A
endfunction

" map `co` and `cO` to insert comments with specific tags
for [key, val] in items(s:comments)
  execute printf('nnoremap cO%s <Cmd>call comment#insert(0, "%s")<CR>', key, val)
  execute printf('nnoremap co%s <Cmd>call comment#insert(1, "%s")<CR>', key, val)
  execute printf('nnoremap co%s <Cmd>call comment#insert(1, "%s")<CR>', toupper(key), val)
endfor
