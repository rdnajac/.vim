let chromatophore#groups = [
      \  'FloatBorder',
      \  'FloatTitle',
      \  'Folded',
      \  'MsgArea',
      \  'SnacksDashboardHeader',
      \  'String',
      \  'WinSeparator',
      \  'helpSectionDelim',
      \ ]

""
" Change highlight colors to match the currbnt mode
function! chromatophore#metachrosis() abort
  let l:color = vim#mode#color()

  execute 'highlight Chromatophore    guifg=' . l:color
  execute 'highlight Chromatophore_ab guifg=' . l:color
  execute 'highlight Chromatophore_b  guifg=' . l:color
  execute 'highlight Chromatophore_c  guifg=' . l:color
  execute 'highlight Chromatophore_y  guifg=' . l:color
  execute 'highlight Chromatophore_z  guifg=' . l:color

  execute 'highlight Chromatophore_a  guibg=' . l:color
endfunction
