scriptencoding=utf-8
let s:flags = {
      \ 'modified': { -> &modified ? ' ' : '' },
      \ 'readonly': { -> &readonly ? ' ' : '' },
      \ 'busy': { -> &busy ? '◐ ' : '' },
      \ }

function! vimline#flag#(name) abort
  return has_key(s:flags, a:name) ? s:flags[a:name]() : ''
endfunction
