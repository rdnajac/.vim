function! s:vimline(name) abort
  return luaeval('require("vimline")["' .. a:name .. '"]()')
endfunction

function! s:lualine_component(name) abort
  return s:vimline(a:name . '_icon')
endfunction

function! s:indicator(condition, icon) abort
  return a:condition ? a:icon : ''
endfunction

let s:sep = ''

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

