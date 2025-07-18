let s:url_scheme_regex = '^[A-Za-z][A-Za-z0-9+.-]*://'

function! bin#mkdir#mkdir(file) abort
  " Skip if URI scheme (e.g., http://, ftp://)
  if a:file =~# s:url_scheme_regex
    return
  endif

  let l:path = expand(a:file)
  let l:resolved = resolve(l:path)
  let l:file = empty(l:resolved) ? a:file : l:resolved
  let l:dir = fnamemodify(l:file, ':p:h')

  if !isdirectory(l:dir)
    call mkdir(l:dir, 'p')
  endif
endfunction

function! bin#mkdir#test() abort
  let l:tests = [
	\ 'http://example.com',
	\ 'ftp://example.com',
	\ 'file:///path/to/file',
	\ 'https://secure-site.com',
	\ 'mailto://user@example.com',
	\ 'oil://host/path',
	\ 'oil-ssh://host/path',
	\ '/usr/local/bin',
	\ '~/notes/todo.md',
	\ './relative/path',
	\ 'C:\Windows\System32',
	\ ]
  for t in l:tests
    if t =~# s:url_scheme_regex
      echom printf('SKIP: %-30s matches URI', t)
    else
      echom printf('MAKE: %-30s is file path', t)
    endif
  endfor
endfunction
