function! vim#apathy#(...) abort
  let orig = getbufvar('', '&path')
  let new = list#join(list#uniq(call('list#split', a:000 + [orig])))
  " let new = list#prepend(orig, a:000)
  call setbufvar('', '&path', new)
  return new
endfunction

function! s:c_apathy() abort
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
    call vim#apathy#(g:[a:varname])
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
endfunction

function! s:python_apathy() abort
  if !exists('g:python_path')
    let s:exe = get(g:, 'python_executable', 'python')
    let s:cmd = s:exe . ' -c "import sys; print(''\n''.join(sys.path))"'
    let s:out = system(s:cmd)[0:-2]
    let g:python_path = v:shell_error ? [] : split(s:out, "\n", 1)
  endif
  call vim#apathy#(g:python_path)
  setlocal suffixesadd =.py,/__init__.py
endif
