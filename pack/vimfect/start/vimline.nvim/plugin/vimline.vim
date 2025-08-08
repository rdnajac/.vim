scriptencoding=utf-8

if !has('nvim')
  finish
endif

lua require('vimline')

" TODO: should these be colored?
" -- hl['StatusLineNC'] = { bg = 'NONE' }
" -- hl['TabLineFill'] = { bg = 'NONE' }
" -- hl['Winbar'] = { bg = 'NONE' }

set showcmdloc=statusline
set statusline=%!MyStatusline()
let &laststatus = has('nvim') ? 3 : 2
set noruler
" set tabline=%!MyTabline()
" set showtabline=2
" set winbar=%!MyWinbar()

function MyStatusline() abort
  let l:line = ''
  " let l:line .= '%#Chromatophore_a# '
  " let [l:root, l:rel_path] = git#RelativePath()
  " let line .= l:rel_path
  " let l:line .= vimline#components#docsymbols()
  let l:line .= ' %='               " Right alignment
  " let l:line .= vimline#components#lspprogress()
  let l:line .= '%#Black#'
  let l:line .= ''
  let l:line .= '%#Chromatophore_y#'
  let l:line .= mode()
  let l:line .= '%{ &busy > 0 ? "◐ " : "" }'
  let l:line .= '%S '
  let l:line .= "%(%{luaeval('(package.loaded[''vim.diagnostic''] and vim.diagnostic.status()) or '''' ')} %)"
  " let l:line .= vimline#recording()
  let l:line .= vimline#components#blink()
  " let l:line .= printf('%10s', vimline#components#mode())
  let l:line .= '%#Black#'
  let l:line .= ''
  return line
endfunction

function! MyTmuxline() abort
  if bufname('%') =~# '^term://'
    " let l:prefix = getcwd()
    let l:prefix = '󱉭 ' . $PWD . ' '
    let l:suffix = 'channel: ' . &channel
  else
    let [l:root, l:suffix] = git#RelativePath()
    let l:prefix = l:root !=# '' ? '󱉭 ' . l:root . '/' : ''
  endif
  let l:line = ''
  let l:line .= '%#Chromatophore_a# '
  let l:line .= l:prefix
  let l:line .= '%#Chromatophore_ab#🭛'
  let l:line .= '%#Chromatophore_b#'
  let l:line .= l:suffix
  let l:line .= ' %#Chromatophore_bc#🭛'
  let l:line .= '%#Chromatophore_c#'
  let l:line .= vimline#flags() . ' '
  return l:line
endfunction

function! Clock() abort
  let l:line = ''
  let l:line .= '%='
  let l:line .= '%#Chromatophore_z#'
  let l:line .= '   ' . strftime('%T') . ' '
  let l:line .= '%#Normal#'
  return l:line
endfunction

" export the statusline
function! TmuxLeft() abort
  return luaeval("require('vimline.tmuxline')(vim.fn['MyTmuxline']())")
endfunction

function! TmuxRight() abort
  return luaeval("require('vimline.tmuxline')(vim.fn['Clock']())")
endfunction

augroup vimline_macro
  autocmd!
  autocmd RecordingEnter * let g:vimline_rec_reg = reg_recording()
  autocmd RecordingLeave * let g:vimline_last_reg = get(g:, 'vimline_rec_reg', '') | unlet g:vimline_rec_reg
  autocmd RecordingEnter,RecordingLeave * redrawstatus
augroup END
