" delete/yank comment
nmap dc dgc
nmap yc ygc

" TODO: make this an opfunc
nmap gy "xyygcc"xp<Up>
nmap gY "xyygcc"xP

" toggle comment line
nmap vv Vgc

" don't capture whitespace in `gc`
nmap gcap gcip

let s:comments = {
      \ 'o': '',
      \ 'b': 'BUG: ',
      \ 'f': 'FIXME: ',
      \ 'h': 'HACK: ',
      \ 'n': 'NOTE: ',
      \ 'p': 'PERF: ',
      \ 't': 'TODO: ',
      \ 'x': 'XXX: ',
      \ 'i': 'stylua: ignore',
      \ }

" map `co` and `cO` to insert comments with specific tags
for [key, val] in items(s:comments)
  execute printf('nmap co%s :call comment#below("%s")<CR>', key, val)
  execute printf('nmap cO%s :call comment#above("%s")<CR>', key, val)
  execute printf('nmap co%s :call comment#above("%s")<CR>', toupper(key), val)
endfor

