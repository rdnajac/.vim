" autoload/path.vim
" utility functions for manipulating filesystem paths

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

function! s:set_repo_path() abort
  let root = git#root()
  if !empty(root)
    " let &path = escape(root, ' ,')
    execute 'set path^=' . root . '/**'
  endif
endfunction

" Split a path into its components, removing any trailing slashes
function! s:split(path) abort
  return split(substitute(a:path, '/\+$', '', ''), '/')
endfunction

" Convert a path to use '~' for the home directory
function! s:home_tilde(path) abort
  return fnamemodify(a:path, ':~')
endfunction

" Return relative path from {base} to {path}
function! s:relative_path(path, base) abort
  let p = s:split(fnamemodify(a:path, ':p'))
  let b = s:split(fnamemodify(a:base, ':p'))
  let i = 0
  while i < len(p) && i < len(b) && p[i] ==# b[i]
    let i += 1
  endwhile
  let rel = repeat(['..'], len(b) - i)
  call extend(rel, p[i:])
  return empty(rel) ? '.' : join(rel, '/')
endfunction

" Build the 'prefix' part for relative_parts
function! s:make_prefix(root, cwd) abort
  let name = fnamemodify(a:root, ':t')
  let rel  = s:relative_path(a:cwd, a:root)
  return name . (rel ==# '.' ? '' : '/' . rel)
endfunction

" Build the 'suffix' part for relative_parts
function! s:make_suffix(file, cwd) abort
  return s:relative_path(a:file, a:cwd)
endfunction

function! vimline#path#root(path) abort
  return git#root(a:path)
endfunction

function! vimline#path#relative(path, base) abort
  return s:relative_path(a:path, a:base)
endfunction

function! vimline#path#relative_parts(...) abort
  let buf  = a:0 ? a:1 : bufnr('%')
  let file = fnamemodify(bufname(buf), ':p')
  if file ==# '' || (!filereadable(file) && !isdirectory(file))
    return ['', '']
  endif

  let root = vimline#path#root(file)
  " let cwd  = getcwd()
  let cwd = getcwd(0,0)

  if !empty(root) && (cwd ==# root || cwd[:strlen(root)] ==# root . '/')
    return [s:make_prefix(root, cwd), s:make_suffix(file, cwd)]
  else
    return [s:home_tilde(cwd), s:make_suffix(file, cwd)]
  endif
endfunction
