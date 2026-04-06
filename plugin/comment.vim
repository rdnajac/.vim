nmap vv gcc
nmap dc dgc
nmap yc ygc

" comment out a line and paste it below
nmap gy "xyygcc"xp

" start a comment above or below the current line
nmap coO O0<Esc>gccA<BS>
nmap coo o0<Esc>gccA<BS>

function! s:title() abort
  execute append(0, substitute(fnamemodify(expand('%'), ':p'), git#root()..'/', '', ''))
  call comment#toggle()
endfunction

nnoremap <leader>fn <Cmd>call <SID>title()<CR>

let s:tags = {
      \ 'b': 'BUG',
      \ 'f': 'FIXME',
      \ 'h': 'HACK',
      \ 'n': 'NOTE',
      \ 't': 'TODO',
      \ 'w': 'WARN',
      \ 'x': 'XXX',
      \ }

" map `co` and `cO` to insert comments with specific tags
for [key, val] in items(s:tags)
  execute $'nmap co{key} o{val}<Esc>gcc<Esc>A'
  execute $'nmap cO{key} O{val}<Esc>gcc<Esc>A'
  execute printf('nmap co%s O%s<Esc>gcc<Esc>A', toupper(key), val)
endfor
