" https://www.reddit.com/r/vim/comments/ufgrl8/journey_to_the_ultimate_imap_jk_esc/
" Map key chord `jk` to <Esc>.
let g:esc_j_lasttime = 0
let g:esc_k_lasttime = 0

function! s:escape(key)
  let l:now = reltimefloat(reltime())
  if a:key ==# 'j'
    let l:other = g:esc_k_lasttime
    let g:esc_j_lasttime = l:now
  elseif a:key ==# 'k'
    let l:other = g:esc_j_lasttime
    let g:esc_k_lasttime = l:now
  endif
  let l:timediff = abs(l:now - l:other)
  if l:timediff <= 0.069 && l:timediff >= 0.001
    let g:esc_j_lasttime = 0
    let g:esc_k_lasttime = 0
    return "\<BS>\<Esc>"
    " TODO: terminal mode
  endif
  return a:key
endfunction

inoremap <expr> j <SID>escape('j')
inoremap <expr> k <SID>escape('k')

vnoremap <expr> j <SID>escape('j')
vnoremap <expr> k <SID>escape('k')

cnoremap <expr> j <SID>escape('j')
cnoremap <expr> k <SID>escape('k')

