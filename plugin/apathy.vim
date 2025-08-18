if exists('g:loaded_apathy')
  finish
endif
let g:loaded_apathy = 1

" vim sets defaults that are only useful for C/C++
if !has('nvim')
  setglobal define=
  setglobal include=
  setglobal includeexpr=
  setglobal path=.,,
endif

" default: `@,48-57,/,.,-,_,+,,,#,$,%,~,=`
setglobal isfname+=@-@

" augroup SetLocalPath
"   autocmd!
"   let s:default_path = escape(&path, '\ ') " store default value of 'path'
"
"   " Always add the current file's directory to the path and tags list if not
"   " already there. Add it to the beginning to speed up searches.
"   autocmd BufRead ~/
" 	\ let s:tempPath = escape(escape(expand("%:p:h"), ' '), '\ ') |
" 	\ exec "set path-=" . s:tempPath |
" 	\ exec "set path-=" . s:default_path |
" 	\ exec "set path^=" . s:tempPath |
" 	\ exec "set path^=" . s:default_path
" augroup END
"
function! s:set_repo_path() abort
  let l:root = git#root()
  if !empty(l:root)
    " let &path = escape(l:root, ' ,')
    execute 'set path^=' . l:root . '/**'
  endif
endfunction


augroup apathy
  autocmd!
  autocmd VimEnter * call s:set_repo_path()
  autocmd FileType javascript,javascriptreact call apathy#javascript#setup()
  autocmd FileType typescript,typescriptreact call apathy#javascript#setup()
  " lcd to the git root on buffer enter
  " autocmd BufEnter * exec 'lcd ' . git#root()
augroup END
