let g:chromatophore_groups = [
      \ 'MsgArea',
      \ 'Pmenu',
      \ 'Pmenusbar',
      \ 'String',
      \ 'FloatBorder',
      \ 'FloatFooter',
      \ 'FloatFooter',
      \ 'MsgSeparator',
      \ 'WinBar',
      \ 'helpSectionDelim',
      \ 'SnacksScratchTitle',
      \  '@markup.raw.markdown_inline',
      \ 'StatusLineNC',
      \ 'StatusLineTermNC',
      \ ]

augroup chromatophore
  autocmd!
  if has('nvim')
    autocmd UIEnter * call chromatophore#setup()
  endif
  autocmd ColorScheme * call chromatophore#setup()
  autocmd ModeChanged * call chromatophore#metachrosis()
augroup END
