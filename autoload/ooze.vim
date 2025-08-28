let s:newline = "\n"

function! s:scroll() abort
  call nvim_win_set_cursor(bufwinid(g:ooze_buffer), [nvim_buf_line_count(g:ooze_buffer), 0])
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

function! ooze#send(text) abort
  if !exists('g:ooze_channel') || empty(g:ooze_channel)
    Warn 'Ooze: no channel selected'
    return 0
  endif

  let l:text = a:text

  if get(g:, 'ooze_auto_exec', 1)
    let l:text .= s:newline
  endif
  let l:chan = str2nr(g:ooze_channel)
  let l:bytes = chansend(l:chan, l:text)

  if get(g:, 'ooze_auto_advance', 1)
    call s:linefeed()
  endif
  if get(g:, 'ooze_auto_scroll', 1)
    call s:scroll()
  endif
  return l:bytes
endfunction

function! ooze#line() abort
  if &buftype ==# 'terminal'
    return '<CR>'
  endif

  let l:line = getline('.')
  let l:ft = &filetype
  if l:ft ==# 'r' || l:ft ==# 'rmd' || l:ft ==# 'quarto'
    Warn 'Ooze does not support R yet.'
    return 0
  endif

  if l:ft ==# 'vim' || l:ft ==# 'lua'
    execute (l:ft ==# 'lua' ? 'lua ' : '') . l:line
    Info (l:ft ==# 'lua' ? ' ' : ' ') . '[[' . l:line . ']]'
    return 1
  endif

  let l:bytes = ooze#send(l:line)

  if  l:bytes > 0
    Info 'Sent ' . l:bytes . ' bytes: [[' . l:line . ']]'
  else
    Warn 'Failed to send line: [[' . l:line . ']]'
    return '<CR>'
  endif
endfunction

function! ooze#file() abort
  if &ft ==# 'vim'
    execute 'source %'
    Info 'Sourced ' . expand('%:p')
  elseif &ft ==# 'lua'
    lua Snacks.debug.run()
  else
    call ooze#send(expand('%:p'))
  endif
endfunction

function! ooze#range(...) range abort
  " TODO: replace newlines with spaces if lua
  call ooze#send(join(getline(a:firstline, a:lastline), "\n"))
endfunction

" function! ooze#operator(type) abort
"   let [l1, l2] = getpos("'[")[1], getpos("']")[1]
"   call ooze#range(l1, l2)
" endfunction

function! ooze#init() abort
  " todo make this buffer-local
  let g:ooze_channel = input('Select ooze channel: ', get(g:, 'ooze_channel', ''))
  Info 'Selected channel: ' . g:ooze_channel
endfunction
