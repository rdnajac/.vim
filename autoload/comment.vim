" autoload/comment.vim
" NOTE:  is <ESC>
function! s:insert_comment(tag, above) abort
  execute 'normal ' . (a:above ? 'O' : 'o') . a:tag . 'gcc'
  execute 'normal! A' " FIXME: doesn't append...
endfunction

function! comment#above(tag) abort
  call s:insert_comment(a:tag, v:true)
endfunction

function! comment#below(tag) abort
  call s:insert_comment(a:tag, v:false)
endfunction
