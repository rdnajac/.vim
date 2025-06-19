" https://www.reddit.com/r/vim/comments/ufgrl8/journey_to_the_ultimate_imap_jk_esc/
" Map key chord `jk` to <Esc>.

let g:esc_j_lasttime = 0
let g:esc_k_lasttime = 0
function! s:escape(key)
  if a:key=='j' | let g:esc_j_lasttime = reltimefloat(reltime()) | endif
  if a:key=='k' | let g:esc_k_lasttime = reltimefloat(reltime()) | endif
  let l:timediff = abs(g:esc_j_lasttime - g:esc_k_lasttime)
  return (l:timediff <= 0.05 && l:timediff >=0.001) ? "\b\e" : a:key
endfunction
inoremap <expr> j <SID>escape('j')
inoremap <expr> k <SID>escape('k')
