scriptencoding=utf-8

" let s:sep = ''
let s:sep = ''
" let s:sep = ' '
" let s:sep = ' '

" components for the various lines in the UI
function! s:indicator(condition, icon) abort
  return a:condition ? a:icon : ''
endfunction

" `~/.config/nvim/lua/util/lualine/components.lua`
" returns an icon or empty string based on the condition
function! s:lualine_component(name) abort
  return luaeval('require("util.lualine.components")["' .. a:name .. '_icon"]()')
endfunction

function ui#components#i_filetype() abort
  let l:icon = s:lualine_component('filetype')
  return s:indicator(!empty(l:icon), l:icon . ' ')
endfunction

function! ui#components#i_copilot() abort
  let l:icon = s:lualine_component('copilot')
  return s:indicator(!empty(l:icon), s:sep . l:icon)
endfunction

function! ui#components#i_treesitter() abort
  let l:icon = s:lualine_component('treesitter')
  return s:indicator(!empty(l:icon), s:sep . l:icon)
endfunction

function! ui#components#i_help() abort
  return s:indicator((&filetype ==# 'help'), s:sep . ' %h')
endfunction

function! ui#components#i_modified() abort
  return s:indicator(&modified, s:sep . '  ')
endfunction

function! ui#components#i_readonly() abort
  return s:indicator(&readonly, s:sep . '  ')
endfunction

function! ui#components#i_recording() abort
  let reg = reg_recording()
  return s:indicator(!empty(reg), '󰑋 ' . reg . ' ')
endfunction
