function! s:split(path) abort
  return split(substitute(a:path, '/\+$', '', ''), '/')
endfunction

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

function! s:home_tilde(path) abort
  return fnamemodify(a:path, ':~')
endfunction

function! s:prefix(root, cwd) abort
  let rel = s:relative_path(a:cwd, a:root)
  let name = fnamemodify(a:root, ':t')
  return name . (rel ==# '.' ? '' : '/' . rel)
endfunction

function! s:suffix(path, cwd) abort
  return s:relative_path(a:path, a:cwd)
endfunction

function! path#relative(...) abort
  let l:buf = a:0 ? a:1 : bufnr('%')
  let l:file = fnamemodify(bufname(l:buf), ':p')
  if l:file ==# '' || (!filereadable(l:file) && !isdirectory(l:file))
    return ['', '']
  endif
  let l:root = git#root(l:file)
  let l:cwd = getcwd()
  if !empty(l:root) && (l:cwd ==# l:root || l:cwd[:strlen(l:root)] ==# l:root . '/')
    let l:prefix = s:prefix(l:root, l:cwd)
    let l:suffix = s:suffix(l:file, l:cwd)
    return [l:prefix, l:suffix]
  else
    return [s:home_tilde(l:cwd), s:suffix(l:file, l:cwd)]
  endif
endfunction
