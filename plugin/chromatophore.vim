if !exists('g:chromatophore_groups')
  let g:chromatophore_groups = [
	\ 'FloatBorder',
	\ 'Folded',
	\ 'MsgArea',
	\ 'StatusLineNC',
	\ 'StatusLineTermNC',
	\ 'String',
	\ 'helpSectionDelim',
	\ ]
endif

augroup chromatophore
  autocmd!
  autocmd ColorScheme * call chromatophore#setup()
  autocmd ModeChanged * call chromatophore#metachrosis()
augroup END

call chromatophore#setup()
