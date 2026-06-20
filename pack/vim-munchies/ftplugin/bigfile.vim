" Vim filetype plugin
" Language:          bigfile
" Maintainer:        me

if exists('b:did_ftplugin')
  finish
endif
let b:did_ftplugin = 1

let s:cpo_save = &cpo
set cpo&vim

" unset potentially-expensive buffer-local options
setlocal conceallevel&
setlocal foldmethod&
setlocal statuscolumn&

let b:undo_ftplugin = 'setl cole< fdm< stc<'
let b:completion = v:false
" let b:minianimate_disable = v:true
let b:minihipatterns_disable = v:true

if exists(':NoMatchParen') == 2
  NoMatchParen
endif

if has('nvim') && nvim_buf_is_valid(0)
  lua vim.schedule(function() vim.bo[0].syntax = vim.filetype.match({buf=0}) or "" end)
endif
