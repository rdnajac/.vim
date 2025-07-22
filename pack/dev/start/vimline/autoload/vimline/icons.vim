" returns an icon or empty string based on the condition
function! s:lualine_component(name) abort
  " return luaeval('require("util.lualine")["' .. a:name .. '_icon"]()')
  return s:vimline(a:name . '_icon')
endfunction

" returns an icon or empty string based on the condition
function! s:vimline(name) abort
  return luaeval('require("vimline")["' .. a:name .. '"]()')
endfunction


" let s:sep = ''
let s:sep = ''
" let s:sep = ' '
" let s:sep = ' '

" components for the various lines in the UI
function! s:indicator(condition, icon) abort
  return a:condition ? a:icon : ''
endfunction

function vimline#icons#filetype() abort
  let l:icon = s:lualine_component('filetype')
  return s:indicator(!empty(l:icon), l:icon . ' ')
endfunction

function! vimline#icons#copilot() abort
  let l:icon = s:lualine_component('copilot')
  return s:indicator(!empty(l:icon), s:sep . l:icon)
endfunction

function! vimline#icons#lsp() abort
  let l:icon = s:lualine_component('lsp')
  return s:indicator(!empty(l:icon), s:sep . l:icon)
endfunction

function! vimline#icons#treesitter() abort
  let l:icon = s:lualine_component('treesitter')
  return s:indicator(!empty(l:icon), s:sep . l:icon)
endfunction

function! vimline#icons#help() abort
  return s:indicator((&filetype ==# 'help'), s:sep . ' %h')
endfunction

function! vimline#icons#modified() abort
  return s:indicator(&modified, s:sep . ' ')
endfunction󰟔

function! vimline#icons#readonly() abort
  return s:indicator(&readonly, s:sep . ' ')
endfunction

function! vimline#icons#recording() abort
  let reg = reg_recording()
  return s:indicator(!empty(reg), '󰑋 ' . reg . ' ')
endfunction
