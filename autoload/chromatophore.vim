if !exists('g:chromatophore_groups')
  let g:chromatophore_groups = [ 'String' ]
endif

function! chromatophore#setup() abort
  let black      = '#000000'
  let eigengrau  = '#16161d'
  let grey       = '#3b4261'
  let mode_color = vim#mode#color()

  highlight! Black guifg=black
  call vim#hl#set('Chromatophore',    mode_color, 'NONE')
  call vim#hl#set('ChromatophoreB',   mode_color, 'NONE',    'bold')
  call vim#hl#set('Chromatophore_a',  mode_color, black,     'bold,reverse')
  call vim#hl#set('Chromatophore_b',  mode_color, grey,      'bold')
  call vim#hl#set('Chromatophore_c',  mode_color, eigengrau)
  call vim#hl#set('Chromatophore_ab', mode_color, grey)
  call vim#hl#set('Chromatophore_bc', grey,       eigengrau)
  call vim#hl#set('Chromatophore_ac', mode_color, eigengrau)
  call vim#hl#set('Chromatophore_z',  mode_color, eigengrau, 'bold')

  call vim#hl#link('Chromatophore', g:chromatophore_groups)
  call vim#hl#link('Chromatophore_a', 'FloatTitle')
  call vim#hl#link('Chromatophore_a', 'PmenuThumb')
endfunction

function! chromatophore#metachrosis() abort
  let l:color = vim#mode#color()
  for l:suffix in ['', '_a', '_ab','_b','_c', '_z']
    execute printf('highlight Chromatophore%s guifg=%s', l:suffix, l:color)
  endfor
endfunction
