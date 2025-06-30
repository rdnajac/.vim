function! s:isGitDir() abort
  return FugitiveIsGitDir()
endfunction

function! s:normalize(path) abort
  let home = expand('~')
  if a:path[0] ==# '~'
    let path = home . a:path[1:]
  else
    let path = a:path
  endif
  let path = substitute(path, '/\+', '/', 'g')
  return path =~# '/$' ? path[:-2] : path
endfunction

" echom s:normalize('~')

function! s:getBufPath() abort
  let name = expand('%:p')
  if name =~# '^oil://'
    return s:Normalize(luaeval("require('oil').get_current_dir()"))
  endif
  return s:Normalize(name)
endfunction

function! s:findGitRoot() abort
  let path = s:GetBufPath()
  let git_dir = luaeval("vim.fs.find('.git', { path = _A[1], upward = true })[1]", [path])
  return empty(git_dir) ? '' : s:Normalize(fnamemodify(git_dir, ':h'))
endfunction

function! s:SplitPath(path) abort
  return split(a:path, '/')
endfunction

function! s:RelativeParts(path, base) abort
  if a:path ==# a:base
    return []
  endif
  let p = s:SplitPath(a:path)
  let b = s:SplitPath(a:base)
  let i = 0
  while i < len(p) && i < len(b) && p[i] ==# b[i]
    let i += 1
  endwhile
  let parts = []
  call extend(parts, repeat(['..'], len(b) - i))
  call extend(parts, p[i:])
  return parts
endfunction

function! s:prefix() abort
  let icon = '󱉭 '
  let root = s:FindGitRoot()
  if root ==# '' || expand('%') ==# ''
    return icon
  endif
  let cwd = s:Normalize(getcwd())
  let rel = cwd[:len(root)] ==# root ? cwd[len(root)+1:] : ''
  return icon . fnamemodify(root, ':t') . (rel !=# '' ? '/' . rel : '') . '/'
endfunction

function! s:prettyPath() abort
  let path = s:GetBufPath()
  if path ==# ''
    return ''
  endif
  let root = s:FindGitRoot()
  let cwd = s:Normalize(getcwd())
  if root ==# '' || path[:len(root)] !=# root
    return fnamemodify(path, ':~') . (path ==# cwd ? '/' : '')
  endif
  let rel_path = path[len(root)+1:]
  let rel_cwd = cwd[len(root)+1:]
  let parts = s:RelativeParts(rel_path, rel_cwd)
  let out = join(parts, '/')
  if out =~# '^../'
    let out = substitute(out, '^\\./\\+', '', '')
    let out = substitute(out, '^\\.\\./\\+', '', '')
  endif
  return empty(parts) ? './' : out
endfunction

function! s:flags() abort
  let out = ''
  if &modified || &readonly
    let out = ' '
    if &modified
      let out .= ' '
    endif
    if &readonly
      let out .= ' '
    endif
  endif
  return out
endfunction

function Line() abort
  let ret = ''
  let ret .= prefix()
endfunction

" echom Line()
