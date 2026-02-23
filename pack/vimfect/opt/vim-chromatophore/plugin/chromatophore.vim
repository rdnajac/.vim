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
  lua require('chromatophore')
  " TODO: use lua render function to handle winbar highlighting
  call add(chromatophores, 'WinBar')
  call add(chromatophores, 'helpSectionDelim')
  call add(chromatophores, '@markup.raw.markdown_inline')
endif

augroup chromatophore
  autocmd!
  if has('nvim')
    autocmd UIEnter * call chromatophore#setup()
  endif
  autocmd ColorScheme * call chromatophore#setup()
  autocmd ModeChanged * call chromatophore#metachrosis()
augroup END
