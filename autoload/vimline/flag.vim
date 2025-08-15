let s:flags = {
      \ 'modified': { -> &modified ? ' ' : '' },
      \ 'readonly': { -> &readonly ? ' ' : '' },
      \ }

function! vimline#flag#(name) abort
  if has_key(s:flags, a:name)
    return s:flags[a:name]()
  endif
  return ''
endfunction
