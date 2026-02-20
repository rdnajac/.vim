scriptencoding utf-8

function! s:err_undo() abort
  if v:shell_error > 0
    silent undo
    redraw
    let msg = 'formatprg "' . &formatprg . '" exited with status ' . v:shell_error
    call vim#notify#error(msg)
  endif
endfunction

" TODO: undojoin?
function! format#buffer() abort
  execute 'normal! gg' . (empty(&formatprg) ? '=' : 'gq') . 'G'
  if empty(&formatprg)
    call format#clean_whitespace()
  else
    call s:err_undo()
  endif
endfunction

function! s:substitute(pattern, replacement, ...) abort
  " see `:h :s_flags`
  let flags = 'ge' . (a:0 ? a:1 : '')
  let cmd = printf('%%s/%s/%s/%s', a:pattern, a:replacement, flags)
  echom 'Running: ' . cmd
  execute 'keeppatterns' cmd
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
    echomsg 'Stripped ' . (size - final_size) . ' bytes of trailing whitespace'
  endif
endfunction

function format#delete_blank_lines() abort
  g/^$/d
endfunction
