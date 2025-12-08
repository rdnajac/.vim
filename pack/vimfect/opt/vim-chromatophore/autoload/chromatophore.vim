if !exists('g:chromatophore_groups')
  let g:chromatophore_groups = [ 'String' ]
endif

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

function! s:color(...) abort
  let l:mode = a:0 ? a:1 : mode(1)
  " Detect true operator-pending only if we're still waiting
  if l:mode =~# '^no' && getchar(1) == 0
    return 'pending'
  endif
  return get(s:mode_map, l:mode[0], 'normal')
endfunction

function! chromatophore#color() abort
  return get(s:mode_color_map, s:color(), s:mode_color_map.normal)
endfunction

function! chromatophore#setup() abort
  let black      = '#000000'
  let eigengrau  = '#16161d'
  let grey       = '#3b4261'
  let mode_color = chromatophore#color()

  highlight! Black guifg=black
  " highlight! Chromatophore_a guifg=
  call vim#hl#set('Chromatophore',    mode_color, 'NONE')
  call vim#hl#set('ChromatophoreB',   mode_color, 'NONE', 'bold')
  " call vim#hl#set('Chromatophore_a',  mode_color, eigengrau,'bold,reverse')
  call vim#hl#set('Chromatophore_a',  black,  mode_color, 'bold')
  call vim#hl#set('Chromatophore_b',  mode_color, grey,       'bold')
  call vim#hl#set('Chromatophore_c',  mode_color, eigengrau)
  call vim#hl#set('Chromatophore_z',  mode_color, eigengrau, 'bold')
  " call vim#hl#set('Chromatophore_ab', mode_color, grey)
  " call vim#hl#set('Chromatophore_bc', grey,       eigengrau)
  " call vim#hl#set('Chromatophore_ac', mode_color, eigengrau)

  call vim#hl#link('Chromatophore', g:chromatophore_groups)

endfunction

function! chromatophore#metachrosis() abort
  let l:color = chromatophore#color() 
  " for l:suffix in ['', '_a', '_b', '_c', '_z']
  for l:suffix in ['', '_b', '_c', '_z']
    execute printf('highlight Chromatophore%s guifg=%s', l:suffix, l:color)
  endfor
  execute 'highlight Chromatophore_a guibg=' . l:color
  execute 'highlight lualine_transitional_lualine_a_normal_to_lualine_b_normal guifg=' . l:color
  lua if  package.loaded['lualine'] then require('lualine').refresh() end
endfunction
