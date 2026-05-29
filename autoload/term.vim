" Shells can emit the `OSC 7` sequence to announce when the current directory (CWD) changed.
" If your terminal doesn't already do this for you, you can configure your shell to emit it.
" print_osc7() { printf '\033]7;file://%s\033\\' "$PWD"; }
" PROMPT_COMMAND='print_osc7'

" OSC 7 format: ESC ] 7 ; file://host/path ESC \
let s:OSC7 = '\e]7;file://'

function! s:is_osc7(seq) abort
  return a:seq =~# s:OSC7
endfunction

function! term#print_request() abort
  if s:is_osc7(v:termrequest)
    Warn v:termrequest
  else
    Info v:termrequest
  endif
endfunction

function! term#handleOSC7() abort
  if !s:is_osc7(v:termrequest)
    return
  endif
  let dir = substitute(v:termrequest, '\e]7;file://[^/]*', '', '')
  " let dir = substitute(dir, '\e\\', '', '')
  if isdirectory(dir) && getcwd() !=# dir
    " Info 'OSC 7 dir change to ' . dir
    execute 'lcd' fnameescape(dir)
  endif
endfunction

let s:newline = "\n"

function! s:scroll() abort
  let winid = bufwinid(g:ooze_buffer)
  if winid > 0
    call win_execute(winid, 'call cursor(getpos("$")[1], 1)')
  endif
endfunction

function! s:linefeed() abort
  let i = line('.')
  while i < line('$')
    let curline = substitute(getline(i + 1), '^\s*', '', '')
    if strlen(curline) > 0
      if !get(g:, 'ooze_skip_comments', 1) || curline !~# '^#'
	call cursor(i + 1, 1)
	return
      endif
    endif
    let i += 1
  endwhile
endfunction

function! s:send(text) abort
  if !exists('g:ooze_channel') || empty(g:ooze_channel)
    Warn 'Ooze: no channel selected'
    return 0
  endif

  let l:text = a:text

  if get(g:, 'ooze_auto_exec', 1)
    let l:text .= s:newline
  endif
  let ch = str2nr(g:ooze_channel)
  let bytes = chansend(ch, l:text)

  if get(g:, 'ooze_auto_advance', 1)
    call s:linefeed()
  endif
  " if get(g:, 'ooze_auto_scroll', 1)
  "   call s:scroll()
  " endif
  return bytes
endfunction

function! s:line() abort
  if &ft =~# '^\%(qf\|pager\)$'
    return -1
  endif
  echomsg 'Ooze: sending line: '
  return ooze#send(getline('.'))
endfunction

function! s:range(...) range abort
  call ooze#send(join(getline(a:firstline, a:lastline), "\n"))
endfunction

" function! ooze#operator(type) abort
"   let [l1, l2] = getpos("'[")[1], getpos("']")[1]
"   call s:range(l1, l2)
" endfunction
