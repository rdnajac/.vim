" augroup SetLocalPath
"   " TODO: fork tpope/apathy
"   " TODO: move to local apathy plugin
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

augroup SetRepoPath
  autocmd!
  autocmd VimEnter * call s:set_repo_path()
augroup END
