scriptencoding utf-8

" undo and report when 'formatprg' failed
function! s:err_undo() abort
  if v:shell_error > 0
    silent undo
    redraw
    call vim#notify#error('formatprg "' . &formatprg . '" exited with status ' . v:shell_error)
  endif
endfunction

" Format [line1, line2]: shell out to 'formatprg' if set, otherwise
" re-indent with '=' (see 'equalprg'/'indentexpr'). Vim's naive internal
" text-wrap fallback is rarely wanted outside of prose.
function! s:format(line1, line2) abort
  if empty(&formatprg)
    execute a:line1 . ',' . a:line2 . '='
  else
    execute a:line1 . ',' . a:line2 . '!' . &formatprg
    call s:err_undo()
  endif
endfunction

" operatorfunc driving `zq`, always over the whole buffer (see the `al`
" text object in autoload/vimrc.vim); see `:h g@`. The view is saved
" around the whole `g@al` in the zq mapping itself, since by the time this
" is invoked the motion has already moved the cursor.
function! format#opfunc(type) abort
  call s:format(line("'["), line("']"))
  if empty(&formatprg)
    call format#clean_whitespace()
  endif
endfunction

function! s:substitute(pattern, replacement, ...) abort
  " see `:h :s_flags`
  let flags = 'ge' . (a:0 ? a:1 : '')
  call vim#with#patterns(printf('%%s/%s/%s/%s', a:pattern, a:replacement, flags))
endfunction

function format#plus_to_backticks() abort
  call s:substitute('^+++$', '```')
endfunction

function format#normalize_quotes() abort
  call s:substitute('[“”]', '"')
endfunction

function! s:strip_trailing_whitespace() abort
  " keeppatterns %s/\s\+$//e
  call s:substitute('\s\+$', '')
endfunction

function! s:strip_trailing_newlines() abort
  " keeppatterns %s/\n\+\%$//e
  call s:substitute('\n\+\%$', '')
endfunction

function! format#clean_whitespace() abort
  let size = line2byte(line('$') + 1) - 1
  call s:strip_trailing_whitespace()
  call s:strip_trailing_newlines()
  let final_size = line2byte(line('$') + 1) - 1

  if final_size != size
    call vim#notify#info('Stripped ' . (size - final_size) . ' bytes of trailing whitespace')
  endif
endfunction

function format#delete_blank_lines() abort
  g/^$/d
endfunction
