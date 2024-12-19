" Rename.vim - Rename current buffer's file
if exists('g:loaded_rename_vim') || &cp || v:version < 704
  finish
endif
let g:loaded_rename_vim = 1

let s:slash_pat = exists('+shellslash') ? '[\/]' : '/'

function! s:separator() abort
  return !exists('+shellslash') || &shellslash ? '/' : '\'
endfunction

function! s:RenameArg(arg) abort
  if a:arg =~# '^[~$]\|^[\/]\|^\a\+:\|^\.\.\=\%(/[\/]$\)'
    return a:arg
  else
    return '%:h/' . a:arg
  endif
endfunction

function! s:FileDest(q_args) abort
  let file = a:q_args
  if file =~# s:slash_pat . '$'
    let file .= expand('%:t')
  elseif isdirectory(file)
    let file .= s:separator() . expand('%:t')
  endif
  return substitute(file, '^\.' . s:slash_pat, '', '')
endfunction

function! g:Move(bang, arg) abort
  let dst = s:FileDest(a:arg)
  let dst = simplify(dst)
  if !a:bang && filereadable(dst)
    let confirm = &confirm
    try
      if confirm | set noconfirm | endif
      execute 'saveas ' . fnameescape(dst)
    finally
      if confirm | set confirm | endif
    endtry
  endif
  if filereadable(@%) && rename(@%, dst)
    echoerr 'Failed to rename "' . @% . '" to "' . dst . '"'
  else
    execute 'file ' . fnameescape(dst)
    setlocal modified
  endif
endfunction

command! -bar -nargs=1 -bang Rename
      \ exe 'Move<bang>' escape(s:RenameArg(<q-args>), '"|')
