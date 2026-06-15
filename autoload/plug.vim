" autoload/plug.vim; overrides `https://junegunn.github.io/vim-plug/`
if !has('nvim') || exists('g:loaded_plug')
  finish
endif
let g:loaded_plug = v:true

" see `:h vim.pack-directory`
let g:plug#home = stdpath('data')..'/site/pack/core/opt'
let $PACKDIR = g:plug#home " export the ENV variable

function! plug#begin(...)
  let g:plugs = []
  " let other plugins override the `Plug` definition
  " if exists('
  " command -nargs=1 -bang Plug call add(g:plugs, <args>)
  command! -nargs=+ -bar Plug call s:snackpack_add(<args>)
endfunction

function! s:snackpack_add(plugin, ...) abort
  let opts = a:0 > 0 ? a:1 : {}
  " TODO: 
  call add(g:plugs, a:plugin)
endfunction

function! plug#end()
  delcommand Plug

  " lua vim.pack.add(vim.tbl_map(vim.fn['git#repo'], vim.g.plugs))
  " call map(g:plugs, '"https://github.com/" .. v:val .. ".git"')
  " lua vim.pack.add(vim.g.plugs)
  lua _G.Plug = require('snackpack').add
  lua Plug(vim.g.plugs)

  command! PlugStatus :packu ++offline
  command! PlugClean  :packd ++all
endfunction
