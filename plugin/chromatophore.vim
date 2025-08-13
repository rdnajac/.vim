" call vim#on_init(function('chromatophore#setup'))
if !exists('g:chromatophore_groups')
  let g:chromatophore_groups = chromatophore#groups
endif

function! s:setup() abort
  let black      = '#000000'
  let grey       = '#3b4261'
  let eigengrau  = '#16161d'
  let mode_color = vim#mode#color()

  call vim#hl#set('Black',            black,        'NONE')
  call vim#hl#set('Chromatophore',    mode_color,   'NONE')
  call vim#hl#set('Chromatophore_a',  black,        mode_color,   'bold')
  call vim#hl#set('Chromatophore_ab', mode_color,   grey)
  call vim#hl#set('Chromatophore_b',  mode_color,   grey,         'bold')
  call vim#hl#set('Chromatophore_bc', grey,         eigengrau)
  call vim#hl#set('Chromatophore_c',  mode_color,   eigengrau)
  call vim#hl#set('Chromatophore_y',  mode_color,   black,        'bold')
  call vim#hl#set('Chromatophore_z',  mode_color,   eigengrau,    'bold')

  call vim#hl#link('Chromatophore', g:chromatophore_groups)

  augroup chromatophore
    autocmd!
    autocmd ColorScheme * call chromatophore#setup()
    autocmd ModeChanged * call chromatophore#metachrosis()
  augroup END

endfunction

call s:setup()
