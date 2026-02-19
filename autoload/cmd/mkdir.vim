" Matches common URI schemes followed by '://'
let s:url_scheme_regex = '^[A-Za-z][A-Za-z0-9+.-]*://'
" a:file!~#'\v^\w+\:\/'

" TODO: allow `file://`
function! s:is_url(fname) abort
  return a:fname =~# s:url_scheme_regex
endfunction

" Create parent directories if they do not exist when saving a file
" but skip if the file path looks like a URI (e.g. scp://, oi//)
function! cmd#mkdir#(file) abort
  if empty(&buftype) && !s:is_url(a:file)
    " need to expand again to handle `~` and `..`
    let dir = fnamemodify(expand(a:file), ':p:h')
    if !isdirectory(dir)
      if exists(':Mkdir') == 2
	execute 'Mkdir' dir
      else
	call mkdir(dir, 'p')
      endif
    endif
  endif
endfunction

function! vim#mkdir#test_regex() abort
  let tests = [
	\ '~/notes/todo.md',
	\ './relative/path',
	\ '/usr/local/bin',
	\ 'C:\Windows\System32',
	\ 'file:///path/to/file',
	\ 'ftp://example.com',
	\ 'http://example.com',
	\ 'https://secure-site.com',
	\ 'mailto://user@example.com',
	\ 'oil-ssh://host/path',
	\ 'oi//host/path',
	\ ]
  for t in tests
    echom printf('%s%s',t =~# s:url_scheme_regex ? '✅ ' : '❌ ', t)
  endfor
endfunction
