let g:chromatophores = [
      \ 'String',
      \ 'FloatBorder',
      \ 'FloatFooter',
      \ 'MsgArea',
      \ 'MsgSeparator',
      \ 'Pmenu',
      \ 'PmenuBorder',
      \ 'PmenuSbar',
      \ 'Title',
      \ 'StatusLineNC',
      \ 'StatusLineTermNC',
      \ 'WinSeparator',
      \ ]

if has('nvim')
  call add(chromatophores, 'WinBar')
  call add(chromatophores, 'helpSectionDelim')
  call add(chromatophores, 'manOptionDesc')
  call add(chromatophores, '@markup.raw.markdown_inline')
  call add(chromatophores, 'MiniIconsGreen')
endif

augroup chromatophore
  autocmd!
  if has('nvim')
    autocmd UIEnter * call chromatophore#setup()
  endif
  autocmd ColorScheme * call chromatophore#setup()
  autocmd ModeChanged * call chromatophore#metachrosis()
augroup END

