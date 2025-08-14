let chromatophore#groups = [
      \  'FloatBorder',
      \  'FloatTitle',
      \  'Folded',
      \  'MsgArea',
      \  'String',
      \  'WinSeparator',
      \  'helpSectionDelim',
      \ ]

function! chromatophore#setup() abort
  let black      = '#000000'
  let grey       = '#3b4261'
  let eigengrau  = '#16161d'
  let mode_color = vim#mode#color()

  highlight! Black guifg=black
  call vim#hl#set('Chromatophore',    mode_color,   'NONE')
  call vim#hl#set('Chromatophore_a',  black,        mode_color,   'bold')
  call vim#hl#set('Chromatophore_bc', grey,         eigengrau)
  call vim#hl#set('Chromatophore_b',  mode_color,   grey,         'bold')
  call vim#hl#set('Chromatophore_c',  mode_color,   eigengrau)
  call vim#hl#set('Chromatophore_y',  mode_color,   black,        'bold')
  call vim#hl#set('Chromatophore_z',  mode_color,   eigengrau,    'bold')

  " TODO: can we inherit the mode color?
  " highlight! link ChromatophoreReverse Chromatophore
  " highlight! ChromatophoreReverse gui=reverse cterm=reverse
  " highlight! link Chromatophore_y Chromatophore
  " highlight! Chromatophore_y guibg=black gui=bold cterm=bold

  call vim#hl#link('Chromatophore', g:chromatophore_groups)
endfunction

""
" Change highlight colors to match the currbnt mode
function! chromatophore#metachrosis() abort
  let l:color = vim#mode#color()

  execute 'highlight Chromatophore    guifg=' . l:color
  execute 'highlight Chromatophore_b  guifg=' . l:color
  execute 'highlight Chromatophore_c  guifg=' . l:color
  execute 'highlight Chromatophore_y  guifg=' . l:color
  execute 'highlight Chromatophore_z  guifg=' . l:color

  execute 'highlight Chromatophore_a  guibg=' . l:color
endfunction
