scriptencoding=utf-8

function! PrettyPath() abort
  let l:line = ''
  let l:prefix = luaeval('require("lazy.spec.ui.lualine.components.path").prefix[1]()')
  let l:suffix = luaeval('require("lazy.spec.ui.lualine.components.path").suffix[1]()')
  let l:mod = luaeval('require("lazy.spec.ui.lualine.components.path").modified[1]()')
  let l:line .= '%#Chromatophore_a# '
  let l:line .= l:prefix
  let l:line .= '%#Chromatophore_ab#🭛'
  let l:line .= '%#Chromatophore_b#'
  let l:line .= l:suffix
  return l:line
endfunction

function! MyStatusLine() abort
  let l:line = ''
  let l:line .= '%<'
  let l:line .= PrettyPath()
  let l:line .= ' '
  let l:line .= &ro ? '  ' : ''
  let l:line .= &ft ==# 'help' ? '%h' : ''
  let l:line .= &mod ? '  ' : ''
  return l:line
endfunction

function! MyTabLine() abort
  let l:line = ''
  let l:line .= '%='
  let l:line .= '%#Chromatophore_z#'
  let l:line .= '   ' . strftime('%T') . ' '
  let l:line .= '%#Normal#'
  return l:line
endfunction

set showcmdloc=statusline

" set statusline=

set tabline=%!MyTabLine()
" set showtabline=2

" set winbar=

" export the statusline
function! TmuxLeft() abort
  return luaeval("require('nvim.ui.tmuxline')(vim.fn['MyStatusLine']())")
endfunction

function! TmuxRight() abort
  return luaeval("require('nvim.ui.tmuxline')(vim.fn['MyTabline']())")
endfunction
