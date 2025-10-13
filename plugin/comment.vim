" plugin/comment.vim
function! s:map_insert_comment(lhs, tag) abort
  execute 'nmap cO'.a:lhs.' :call comment#above("'.a:tag.'")<CR>'
  execute 'nmap co'.toupper(a:lhs).' :call comment#above("'.a:tag.'")<CR>'
  execute 'nmap co'.a:lhs.' :call comment#below("'.a:tag.'")<CR>'
endfunction

call s:map_insert_comment('o', '')
call s:map_insert_comment('t', 'TODO: ')
call s:map_insert_comment('f', 'FIXME: ')
call s:map_insert_comment('h', 'HACK: ')
call s:map_insert_comment('b', 'BUG: ')
call s:map_insert_comment('p', 'PERF: ')
call s:map_insert_comment('x', 'XXX: ')
call s:map_insert_comment('i', 'stylua: ignore')
