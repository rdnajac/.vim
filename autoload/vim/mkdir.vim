" Matches common URI schemes followed by '://'
let s:url_scheme_regex = '^[A-Za-z][A-Za-z0-9+.-]*://'
" a:file!~#'\v^\w+\:\/'

" Create parent directories if they do not exist when saving a file
" but skip if the file path looks like a URI (e.g. scp://, oil://)
function! vim#mkdir#(file) abort
  if empty('&buftype') && a:file ==# s:url_scheme_regex
    let l:dir = fnamemodify(a:file, ':p:h')
    if !isdirectory(l:dir)
      call mkdir(l:dir, 'p')
    endif
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
    echom printf('%s%s',t =~# s:url_scheme_regex ? '✅ ' : '❌ ', t)
  endfor
endfunction
