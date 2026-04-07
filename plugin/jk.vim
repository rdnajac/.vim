" https://www.reddit.com/r/vim/comments/ufgrl8/journey_to_the_ultimate_imap_jk_esc/
" Map key chord `jk` to <Esc>.

let g:esc_j_lasttime = 0
let g:esc_k_lasttime = 0

function! s:stopinsert()
  return mode() ==# 't' ? "\<C-\>\<C-N>" : "\<Esc>"
endfunction

function! s:escape(key)
  let now = reltimefloat(reltime())
  execute printf('let g:esc_%s_lasttime = %s', a:key, now)
  let other = a:key ==# 'j' ? g:esc_k_lasttime : g:esc_j_lasttime
  let diff = abs(now - other)
  return diff <= 0.1 && diff >= 0.001 ? "\<BS>"..s:stopinsert() : a:key
endfunction

" map the escape chord in all modes where it makes sense
for mode in ['i', 'v', 'c', 't']
  for key in ['j', 'k']
    execute $'{mode}noremap <expr> {key} <SID>escape("{key}")'
  endfor
endfor

" handle wrapped lines better by preferring `gj` and `gk`
let s:keys = [ 'j', 'k' , '<Down>', '<Up>']
for [i, key] in items(s:keys)
  let dir = s:keys[i % 2] " limit dir to only j/k
  execute printf("nnoremap <expr> %s v:count ? '%s' : 'g%s'", key, dir, dir)
  execute printf("xnoremap <expr> %s v:count ? '%s' : 'g%s'", key, dir, dir)
endfor
unlet s:keys
