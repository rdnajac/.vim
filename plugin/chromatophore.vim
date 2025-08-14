if !exists('g:chromatophore_groups')
  let g:chromatophore_groups = chromatophore#groups
endif

augroup chromatophore
  autocmd!
  autocmd ColorScheme * call chromatophore#setup()
  autocmd ModeChanged * call chromatophore#metachrosis()
augroup END

call chromatophore#setup()
