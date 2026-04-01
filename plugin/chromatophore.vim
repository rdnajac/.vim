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

augroup chromatophore
  autocmd!
  if has('nvim')
    autocmd UIEnter * call chromatophore#setup()
  endif
  autocmd ColorScheme * call chromatophore#setup()
  autocmd ModeChanged * call chromatophore#metachrosis()
  " HACK:
  au FileType snacks_dashboard lua vim.schedule(function() vim.cmd('doautocmd ColorScheme') end)
augroup END

if has('nvim')
  function! s:add(group) abort
    call add(g:chromatophores, a:group)
  endfunction
  call s:add('WinBar')
  call s:add('helpSectionDelim')
  call s:add('manOptionDesc')
  call s:add('@markup.raw.markdown_inline')
  call s:add('MiniIconsGreen')
  call s:add('SnacksDashboardDesc')
  call s:add('SnacksDashboardHeader')
  call s:add('SnacksDashboardIcon')
  call s:add('SnacksDashboardKey')
  call s:add('SnacksDashboardNormal')
  call s:add('SnacksDashboardSpecial')
  call s:add('SnacksDashboardTerminal')
  call s:add('SnacksIndentScope')
  hi! SnacksDashboardFile guifg=#2AC3DE gui=bold
endif
