" Matches common URI schemes followed by '://'
let s:url_scheme_regex = '^[A-Za-z][A-Za-z0-9+.-]*://'
" a:file!~#'\v^\w+\:\/'

function! s:is_url(fname) abort
  return a:fname =~# s:url_scheme_regex && a:fname !~# '^file://'
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

function! s:test() abort
  " {input -> expected is_url result}
  let tests = {
	\ '~/notes/todo.md':        0,
	\ './relative/path':        0,
	\ '/usr/local/bin':         0,
	\ 'C:\Windows\System32':    0,
	\ 'file:///path/to/file':   0,
	\ 'file://path/to/file':    0,
	\ 'ftp://example.com':      1,
	\ 'http://example.com':     1,
	\ 'https://secure-site.com': 1,
	\ 'mailto://user@example.com': 1,
	\ 'oil-ssh://host/path':    1,
	\ 'oi//host/path':          0,
	\ }
  let passed = 0
  let failed = 0
  for [t, expected] in items(tests)
    let got = s:is_url(t)
    if got == expected
      let passed += 1
      echom printf('✅ %s', t)
    else
      let failed += 1
      echom printf('❌ %s  (expected %d, got %d)', t, expected, got)
    endif
  endfor
  echom printf('%d passed, %d failed', passed, failed)
endfunction

call s:test()
