let s:mode_color_map = {
      \ 'normal':   '#39FF14',
      \ 'visual':   '#F7768E',
      \ 'select':   '#FF9E64',
      \ 'replace':  '#FF007C',
      \ 'terminal': '#BB9AF7',
      \ 'shell':    '#14AEFF',
      \ 'pending':  '#E0AF68',
      \ }
" \ 'command':  '#FFFFFF',
" \ 'insert':   '#9ECE6A',

" Map Vim mode chars to normalized mode keys
let s:mode_map = {
      \ 'n': 'normal',
      \ 'i': 'insert',
      \ 'v': 'visual',
      \ 'V': 'visual',
      \ "\<C-V>": 'visual',
      \ 's': 'select',
      \ "\<C-S>": 'select',
      \ 'R': 'replace',
      \ 'c': 'command',
      \ 'r': 'command',
      \ 't': 'terminal',
      \ '!': 'shell',
      \ }

function! vim#mode#(...) abort
  let l:mode = a:0 ? a:1 : mode(1)
  " Detect true operator-pending only if we're still waiting
  if l:mode =~# '^no' && getchar(1) == 0
    return 'pending'
  endif
  return get(s:mode_map, l:mode[0], 'normal')
endfunction

function! vim#mode#color() abort
  return get(s:mode_color_map, vim#mode#(), s:mode_color_map.normal)
endfunction
