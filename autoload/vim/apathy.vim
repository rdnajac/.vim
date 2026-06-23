function! vim#apathy#(...) abort
  let orig = getbufvar('', '&path')
  let new = call('list#prepend', [orig] + a:000)
  call setbufvar('', '&path', new)
  return new
endfunction

function! vim#apathy#sh() abort
  setlocal define=\\<\\%(\\i\\+\\s*()\\)\\@=
  setlocal include=^\\s*\\%(\\.\\\|source\\)\\s
  call vim#apathy#(split($PATH, ':'))
endfunction

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
  if !has('nvim')
    setlocal include=^\\s*#\\s*include\\s*[\"<]\\@=
    setlocal includeexpr&
    setlocal define&
  endif
  call vim#apathy#(g:[a:varname])
endfunction

function! vim#apathy#c() abort
  call s:apathy('c_path', 'c')
endfunction

function! vim#apathy#cpp() abort
  call s:apathy('cpp_path', 'c++')
endfunction

function! vim#apathy#python() abort
  if !exists('g:python_path')
    let s:exe = get(g:, 'python_executable', 'python')
    let s:cmd = s:exe . ' -c "import sys; print(''\n''.join(sys.path))"'
    let s:out = system(s:cmd)[0:-2]
    let g:python_path = v:shell_error ? [] : split(s:out, "\n", 1)
  endif
  call vim#apathy#(g:python_path)
  setlocal suffixesadd =.py,/__init__.py
endfunction
