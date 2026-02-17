let g:chromatophores = [
      \ 'String',
      \ 'FloatBorder',
      \ 'FloatFooter',
      \ 'MsgArea',
      \ 'MsgSeparator',
      \ 'Pmenu',
      \ 'PmenuBorder',
      \ 'PmenuSbar',
      \ 'StatusLineNC',
      \ 'StatusLineTermNC',
      \ 'WinSeparator',
      \ ]

if has('nvim')
  " TODO: use lua render function to handle winbar highlighting
  call add(chromatophores, 'winbar')
  call add(chromatophores, 'helpSectionDelim')
  call add(chromatophores, '@markup.raw.markdown_inline')
  " call add(chromatophores, 'SnacksPickerBoxTitle')
  " call add(chromatophores, 'SnacksPickerInputBorder')
  " hi clear SnacksPickerInputBorder
  " call add(g:chromatophores, 'SnacksDashboardHeader')
endif

augroup chromatophore
  autocmd!
  if has('nvim')
    autocmd UIEnter * call chromatophore#setup()
  endif
  autocmd ColorScheme * call chromatophore#setup()
  autocmd ModeChanged * call chromatophore#metachrosis()
augroup END
