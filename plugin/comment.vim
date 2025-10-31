" plugin/comment.vim
let s:comment_map = {
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

" maps `co` and `cO` to insert comments with specific tags
function! s:map_insert_comment(lhs, tag) abort
  execute printf('nmap co%s :call comment#below("%s")<CR>', a:lhs, a:tag)
  execute printf('nmap cO%s :call comment#above("%s")<CR>', a:lhs, a:tag)
  execute printf('nmap co%s :call comment#above("%s")<CR>', toupper(a:lhs), a:tag)
endfunction

for [key, val] in items(s:comment_map)
  call <SID>map_insert_comment(key, val)
endfor
