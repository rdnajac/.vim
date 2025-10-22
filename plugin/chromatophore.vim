let g:chromatophore_groups = [
      \ 'FloatBorder',
      \ 'FloatFooter',
      \ 'FloatFooter',
      \ 'MsgArea',
      \ 'Pmenu',
      \ 'Pmenusbar',
      \ 'StatusLineNC',
      \ 'StatusLineTermNC',
      \ 'String',
      \ 'MsgSeparator',
      \ 'helpSectionDelim',
      \ 'SnacksScratchTitle',
      \  '@markup.raw.markdown_inline',
      \ ]

augroup chromatophore
  autocmd!
  if has('nvim')
    autocmd UIEnter * call chromatophore#setup()
  endif
  autocmd ColorScheme * call chromatophore#setup()
  autocmd ModeChanged * call chromatophore#metachrosis()
augroup END
