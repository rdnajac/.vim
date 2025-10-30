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
      \ 'SnacksDashboardHeader',
      \ 'SnacksDashboardFooter',
      \ 'SnacksDashboardTerminal',
      \  '@markup.raw.markdown_inline',
      \ 'StatusLineNC',
      \ 'StatusLineTermNC',
      \ ]

      " \ 'SnacksDashboardDesc',
      " \ 'SnacksDashboardIcon',
      " \ 'SnacksDashboardKey',
augroup chromatophore
  autocmd!
  if has('nvim')
    autocmd UIEnter * call chromatophore#setup()
  endif
  autocmd ColorScheme * call chromatophore#setup()
  autocmd ModeChanged * call chromatophore#metachrosis()
augroup END
