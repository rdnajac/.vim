" if !exists('g:chromatophores')
" let g:chromatophores = [ 'String' ]
let g:chromatophores = [
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
" endif

" call add(g:chromatophores, 'SnacksDashboardHeader')

augroup chromatophore
  autocmd!
  " if has('nvim') | autocmd UIEnter * call chromatophore#setup() | endif
autocmd ColorScheme * call chromatophore#setup()
autocmd ModeChanged * call chromatophore#metachrosis()
augroup END
