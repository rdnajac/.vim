function! s:insert_comment(tag, above) abort
  let prefix = a:above ? 'O' : 'o'
  let content = a:tag !=# '' ? a:tag . ': ' : ''
  return prefix . "\<Esc>Vc" . content . "¿\<Esc>gccA\<BS>"
endfunction

function! comment#above(tag) abort
  execute 'normal' s:insert_comment(a:tag, v:true)
endfunction

function! comment#below(tag) abort
  execute 'normal' s:insert_comment(a:tag, v:false)
endfunction
