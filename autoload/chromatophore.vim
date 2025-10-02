if !exists('g:chromatophore_groups')
  let g:chromatophore_groups = [
	\ 'FloatBorder',
	\ 'Folded',
	\ 'MsgArea',
	\ 'StatusLineNC',
	\ 'StatusLineTermNC',
	\ 'String',
	\ 'helpSectionDelim',
	\  '@markup.raw.markdown_inline'
	\ ]
endif

function! chromatophore#setup() abort
  let black      = '#000000'
  let grey       = '#3b4261'
  let eigengrau  = '#16161d'
  let mode_color = vim#mode#color()

  highlight! Black guifg=black
  call vim#hl#set('Chromatophore',    mode_color,  'NONE')
  call vim#hl#set('ChromatophoreB',   mode_color,  'NONE',        'bold')
  call vim#hl#set('Chromatophore_a',  black,        mode_color,   'bold')
  call vim#hl#set('Chromatophore_y',  mode_color,   black,        'bold')
  call vim#hl#set('Chromatophore_b',  mode_color,   grey,         'bold')
  call vim#hl#set('Chromatophore_c',  mode_color,   eigengrau)
  call vim#hl#set('Chromatophore_z',  mode_color,   eigengrau,    'bold')
  call vim#hl#set('Chromatophore_bc', grey,         eigengrau)

  call vim#hl#link('Chromatophore', g:chromatophore_groups)
  call vim#hl#link('Chromatophore_a', 'FloatTitle')
  call vim#hl#link('Chromatophore_a', 'StatusLine')
  " call vim#hl#link('Chromatophore_a', 'FloatTitle')
endfunction

""
" Change highlight colors to match the currant mode
function! chromatophore#metachrosis() abort
  let l:color = vim#mode#color()

  execute 'highlight Chromatophore    guifg=' . l:color
  execute 'highlight Chromatophore_b  guifg=' . l:color
  execute 'highlight Chromatophore_c  guifg=' . l:color
  execute 'highlight Chromatophore_y  guifg=' . l:color
  execute 'highlight Chromatophore_z  guifg=' . l:color

  execute 'highlight Chromatophore_a  guibg=' . l:color
endfunction
