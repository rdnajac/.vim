" stopinsert with jk
let g:esc_j_lasttime = 0
let g:esc_k_lasttime = 0
let s:max_delay = 0.2
" let s:backspace = "\<BS>"
let s:backspace = "\b"
function! s:stopinsert() abort
  " return mode() ==# 't' ? "\<C-\>\<C-N>" : "\<Esc>"
  return mode() ==# 't' ? "" : ""
endfunction

" if the keys were pressed within 100ms of each other, treat it as an escape chord
" use backspace to remove the first key press from the buffer, then send the escape sequence
" TODO: function returning whether or not we should escape; handle actions separately
function! jk#escape(key)
  exe 'let g:esc_'..a:key..'_lasttime = '..reltimefloat(reltime())
  let diff = abs(g:esc_j_lasttime - g:esc_k_lasttime)
  if diff > s:max_delay || diff < 0.001
    return a:key
  endif
  return s:backspace..s:stopinsert()
  " stopinsert
  " return 'dh'
endfunction

function! jk#setup_mappings() abort
  " if has('nvim')
  " else
    for mode in ['i', 'v',  't']
      for key in ['j', 'k']
	execute $'{mode}noremap <expr> {key} jk#escape("{key}")'
      endfor
    endfor
    " noremap <expr> j jk#escape('j')
    " noremap <expr> k jk#escape('k')
  " endif
endfunction
