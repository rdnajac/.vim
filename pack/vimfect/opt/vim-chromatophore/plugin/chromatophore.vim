let g:chromatophore_groups = [
      \ 'String',
      \ 'FloatBorder',
      \ 'FloatFooter',
      \ 'FloatFooter',
      \ 'MsgArea',
      \ 'MsgSeparator',
      \ 'Pmenu',
      \ 'Pmenusbar',
      \ 'StatusLineNC',
      \ 'StatusLineTermNC',
      \ 'WinBar',
      \ 'helpSectionDelim',
      \ '@markup.raw.markdown_inline',
      \ ]

augroup chromatophore
  autocmd!
  if has('nvim')
    autocmd UIEnter * call chromatophore#setup()
  endif
  autocmd ColorScheme * call chromatophore#setup()
  autocmd ModeChanged * call chromatophore#metachrosis()
augroup END
