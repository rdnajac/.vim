" https://www.reddit.com/r/vim/comments/ufgrl8/journey_to_the_ultimate_imap_jk_esc/
" Map key chord `jk` to <Esc>.
let g:esc_j_lasttime = 0
let g:esc_k_lasttime = 0

let s:escape = "\<BS>\<Esc>"
let s:term_escape = "\<BS>\<C-\>\<C-N>"

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
    return mode() ==# 't' ? s:term_escape : s:escape
  endif
  return a:key
endfunction

for mode in ['i', 'v', 'c', 't']
  for key in ['j', 'k']
    execute mode . 'noremap <expr> ' . key . ' <SID>escape(''' . key . ''')'
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
