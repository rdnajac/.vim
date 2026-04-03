nmap vv gcc
nmap dc dgc
nmap yc ygc

" comment out a line and paste it below
nmap gy "xyygcc"xp

" start a comment above or below the current line
nmap coO O0<Esc>gccA<BS>
nmap coo o0<Esc>gccA<BS>

function! s:toggle_comment() abort
  " vint: -ProhibitCommandRelyOnUser
  normal gcc
  " vint: +ProhibitCommandRelyOnUser
endfunction

function! s:title() abort
  let fname = fnamemodify(expand('%'), ':p')
  let fname = substitute(fname, git#root(), '', '')
  let fname = substitute(fname, '^\/*', '', '')
  " return fname
  execute append(0, fname)
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

function! s:comment(above, tag) abort
  execute 'normal!' .. (a:above ? 'O' : 'o') .. a:tag
  if !comment#syntax_match(getpos('.'))
    call s:toggle_comment()
  endif
  if a:tag =~ ':\s'
    startinsert!
  endif
endfunction

" map `co` and `cO` to insert comments with specific tags
for [key, val] in items(s:comments)
  execute printf('nnoremap cO%s <Cmd>call <SID>comment(0, "%s")<CR>', key, val)
  execute printf('nnoremap co%s <Cmd>call <SID>comment(1, "%s")<CR>', key, val)
  execute printf('nnoremap co%s <Cmd>call <SID>comment(1, "%s")<CR>', toupper(key), val)
endfor
