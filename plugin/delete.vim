" Delete.vim - Delete current buffer's file from disk and unload the buffer
if exists('g:loaded_delete_vim') || &cp || v:version < 704
  finish
endif
let g:loaded_delete_vim = 1

function! s:Delete(path) abort
  if has('patch-7.4.1107') && isdirectory(a:path)
    return delete(a:path, 'd')
  else
    return delete(a:path)
  endif
endfunction

function! s:DeleteError(file) abort
  if empty(getftype(a:file))
    return 'Could not find "' . a:file . '" on disk'
  else
    return 'Failed to delete "' . a:file . '"'
  endif
endfunction

command! -bar -bang Delete
      \ if <bang>1 && !(line('$') == 1 && empty(getline(1)) || getftype(@%) !=# 'file') |
      \   echoerr "File not empty (add ! to override)" |
      \ else |
      \   let s:file = expand('%:p') |
      \   execute 'bdelete<bang>' |
      \   if !bufloaded(s:file) && s:Delete(s:file) |
      \     echoerr s:DeleteError(s:file) |
      \   endif |
      \   unlet s:file |
      \ endif
