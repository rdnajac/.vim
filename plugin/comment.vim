" plugin/comment.vim
function! s:map_insert_comment(lhs, tag) abort
  execute 'nmap cO'.a:lhs.' :call comment#above("'.a:tag.'")<CR>'
  execute 'nmap co'.toupper(a:lhs).' :call comment#above("'.a:tag.'")<CR>'
  execute 'nmap co'.a:lhs.' :call comment#below("'.a:tag.'")<CR>'
endfunction

call <SID>map_insert_comment('o', '')
call <SID>map_insert_comment('t', 'TODO: ')
call <SID>map_insert_comment('f', 'FIXME: ')
call <SID>map_insert_comment('h', 'HACK: ')
call <SID>map_insert_comment('b', 'BUG: ')
call <SID>map_insert_comment('p', 'PERF: ')
call <SID>map_insert_comment('x', 'XXX: ')
call <SID>map_insert_comment('n', 'NOTE: ')
call <SID>map_insert_comment('i', 'stylua: ignore')
