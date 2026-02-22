if !exists('g:chromatophores')
  let g:chromatophores = [ 'String' ]
endif

function! chromatophore#setup() abort
  let black      = '#000000'
  let eigengrau  = '#16161d'
  let grey       = '#3b4261'
  let mode_color = chromatophore#color()

  highlight! Black guifg=black
  " highlight! Chromatophore_a guifg=
  call s:hl_set('Chromatophore',    mode_color, 'NONE')
  call s:hl_set('ChromatophoreB',   mode_color, 'NONE', 'bold')
  " call s:hl_set('Chromatophore_a',  mode_color, eigengrau,'bold,reverse')
  call s:hl_set('Chromatophore_a',  black,  mode_color, 'bold')
  call s:hl_set('Chromatophore_b',  mode_color, grey,       'bold')
  call s:hl_set('Chromatophore_c',  mode_color, eigengrau)
  call s:hl_set('Chromatophore_z',  mode_color, eigengrau, 'bold')
  call s:hl_set('Chromatophore_ab', mode_color, grey)
  call s:hl_set('Chromatophore_bc', grey,       eigengrau)
  call s:hl_set('Chromatophore_cN', eigengrau, 'NONE')
  call s:hl_set('Chromatophore_ac', mode_color, eigengrau)
  call s:hl_link('Chromatophore', g:chromatophores)
endfunction

let s:mode_color_map = {
      \ 'normal':   '#39FF14',
      \ 'visual':   '#F7768E',
      \ 'select':   '#FF9E64',
      \ 'replace':  '#FF007C',
      \ 'command':  '#E0AF68',
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

function! s:color(...) abort
  let l:mode = a:0 ? a:1 : mode(1)
  " Detect true operator-pending only if we're still waiting
  if l:mode =~# '^no' && getchar(1) == 0
    return 'pending'
  endif
  return get(s:mode_map, l:mode[0], 'normal')
endfunction

function! s:hl_set(name, fg, bg, ...) abort
  let attr = a:0 ? a:1 : ''
  let cmd = 'highlight ' . a:name . ' guifg=' . a:fg . ' guibg=' . a:bg
  if !empty(attr)
    let cmd .= ' gui=' . attr
  endif
  execute cmd
endfunction

function! s:hl_link(target, groups) abort
  for group in a:groups
    execute 'highlight! link ' . group . ' ' . a:target
  endfor
endfunction

function! chromatophore#color() abort
  return get(s:mode_color_map, s:color(), s:mode_color_map.normal)
endfunction

function! chromatophore#metachrosis() abort
  let color = chromatophore#color()
  for suffix in ['', '_b', '_c', '_z']
    execute printf('highlight Chromatophore%s guifg=%s', suffix, color)
  endfor
  execute 'highlight Chromatophore_a guibg=' . l:color
endfunction
