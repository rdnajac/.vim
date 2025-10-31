function! s:CPreProcIncludes(exe, opts) abort
  let paths = []
  let active = 0
  for line in executable(a:exe) ? split(system(a:exe . ' ' . a:opts), "\n") : []
    if line =~# '^#include '
      let active = 1
    elseif line =~# '^\S'
      let active = 0
    elseif active
      call add(paths, matchstr(line, '\S\+'))
    endif
  endfor
  return paths
endfunction

function! s:apathy(varname, lang) abort
  if !exists('g:' . a:varname)
    let g:c_path_compiler = get(g:, 'c_path_compiler', executable('clang') ? 'clang' : 'gcc')
    let g:[a:varname] = ['.'] + s:CPreProcIncludes(g:c_path_compiler, '-E -v -x ' . a:lang . ' /dev/null')
  endif
  call list#Prepend('path', g:[a:varname])
endfunction

if &filetype ==# 'cpp'
  call s:apathy('cpp_path', 'c++')
else
  call s:apathy('c_path', 'c')
endif

if !has('nvim')
  setlocal include=^\\s*#\\s*include\\s*[\"<]\\@=
  setlocal includeexpr&
  setlocal define&
endif
