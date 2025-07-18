function! ooze#test() abort
  echom 'ooze exists!'
endfunction

let s:newline = "\n"

function! s:scroll() abort
  if exists('g:ooze_buffer') && bufexists(g:ooze_buffer)
    let winid = bufwinid(g:ooze_buffer)
    if winid > 0
      let line_count = nvim_buf_line_count(g:ooze_buffer)
      call nvim_win_set_cursor(winid, [line_count, 0])
    endif
  endif
endfunction

function! s:ooze(text) abort
  if g:ooze_auto_exec
    let text = a:text . s:newline
  endif
  call chansend(g:ooze_channel, text)
  " if g:ooze_auto_scroll | call s:scroll() | endif
call s:scroll()
endfunction

function! ooze#linefeed() abort
  let i = line('.')
  while i < line('$')
    let curline = substitute(getline(i + 1), '^\s*', '', '')
    if strlen(curline) > 0
      " if !(exists('g:ooze_skip_comments') && g:ooze_skip_comments && curline =~ '^#')
      call cursor(i + 1, 1)
      return
      " endif
    endif
    let i += 1
  endwhile
endfunction

function! ooze#sendline() abort
  let line = getline(".")
  " don't send empty lines
  if strlen(line) > 0
    call s:ooze(line)
  else
    call ooze#linefeed()
  endif
endfunction

function! s:tostring()
  try
    let a_orig = @a
    silent! normal! gv"ay
    return @a
  finally
    let @a = a_orig
  endtry
endfunction

" FIXME: see clam.vim
function! ooze#visual() range abort
  let l:lines = getline(a:firstline, a:lastline)
  call chansend(g:ooze_channel, join(l:lines, "\n") . "\n")
endfunction

function! ooze#runfile() abort
  let l:file = expand('%:p')
  call s:ooze(l:file)
endfunction

function! ooze#cr() abort
  if v:lua.Snacks.util.var(0, 'ooze_send_on_enter', 0) == 1
    call ooze#sendline()
    call ooze#linefeed()
    return ''
  else
    return "\<CR>"
  endif
endfunction

function! ooze#operator(type) abort
  let [l1, c1] = getpos("'[")[1:2]
  let [l2, c2] = getpos("']")[1:2]
  let lines = getline(l1, l2)

  if a:type ==# 'v' || a:type ==# 'char'
    let lines[-1] = lines[-1][: c2 - 1]
    let lines[0] = lines[0][c1 - 1 :]
  endif

  call chansend(g:ooze_channel, join(lines, "\n") . "\n")
  if g:ooze_auto_scroll | call s:scroll() | endif
endfunction
