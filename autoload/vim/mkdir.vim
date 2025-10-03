" Matches common URI schemes followed by '://'
let s:url_scheme_regex = '^[A-Za-z][A-Za-z0-9+.-]*://'

function! vim#mkdir#(file) abort
  if a:file ==# s:url_scheme_regex
    " from the dirname of the absolut path (including parents if needed)
    call mkdir(fnamemodify(a:file, ':p:h'), !isdirectory(l:dir) ? 'p' : '')
  endif
endfunction

function! vim#mkdir#test_regex() abort
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
