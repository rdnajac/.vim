if executable('ruff')
  let &l:formatprg = 'ruff format -q --stdin-filename % -'
endif

if !exists('g:python_path')
  let s:exe = get(g:, 'python_executable', 'python')
  let s:cmd = s:exe . ' -c "import sys; print(''\n''.join(sys.path))"'
  let s:out = system(s:cmd)[0:-2]
  let g:python_path = v:shell_error ? [] : split(s:out, "\n", 1)
endif
call apathy#Prepend('path', g:python_path)
call apathy#Prepend('suffixesadd', '.py,/__init__.py')
