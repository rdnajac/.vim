let s:newline = "\n"

" FIXME: make this compatible with vim
function! s:scroll() abort
  call nvim_win_set_cursor(bufwinid(g:ooze_buffer), [nvim_buf_line_count(g:ooze_buffer), 0])
endfunction

function! s:linefeed(skip_comments) abort
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
  if &ft ==# 'qf\|pager'
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

" let g:ooze_channel = input('Select ooze channel: ', get(g:, 'ooze_channel', ''))
tnoremap <expr> <C-R> '<C-\><C-N>"'.nr2char(getchar()).'pi'

augroup vimrc.term
  autocmd BufEnter term://*:R\ * startinsert
  autocmd BufEnter term://*/copilot startinsert
  autocmd TermOpen * let g:last_term_channel = &channel
  autocmd TermOpen * let g:last_term_buffer = bufnr('%')
augroup END
