
let s:bufnr = -1
let s:winnr = -1

if !hlexists('WhichKeyFloating')
  hi default link WhichKeyFloating Pmenu
endif

function! s:hide_cursor() abort
  " Hides/restores cursor at the start/end of the guide, works in vim
  " Snippets from vim-game-code-break
  augroup which_key_cursor
    autocmd!
    execute 'autocmd BufLeave <buffer> set t_ve=' . escape(&t_ve, '|')
    execute 'autocmd VimLeave <buffer> set t_ve=' . escape(&t_ve, '|')
  augroup END
  setlocal t_ve=
endfunction

function! s:split_or_new() abort
  let position = g:which_key_position ==? 'topleft' ? 'topleft' : 'botright'
  let splitcmd = g:which_key_vertical ? '1vnew' : '1new'
  noautocmd execute 'keepjumps' position splitcmd

  let s:bufnr = bufnr('%')
  augroup which_key_leave
    autocmd!
    autocmd WinLeave <buffer> call which_key#window#close()
  augroup END
endfunction

function! s:append_prompt(rows) abort
  let rows = a:rows
  let prompt = which_key#trigger().'- '.which_key#window#name()
  let rows += ['', prompt]
  return rows
endfunction

function! s:floating_win_col_offset() abort
  return (&number ? strlen(line('$')) : 0) + (exists('&signcolumn') && &signcolumn ==# 'yes' ? 2: 0)
endfunction

function! s:show_popup(rows) abort
  if !exists('s:popup_id')
    let s:popup_id = popup_create('which key?', {'border': [1,1,1,1], 'highlight': "WhichKeyFloating"})
    call popup_setoptions(s:popup_id, {"borderchars": ["─", "│", "─", "│", "╭", "╮", "╯", "╰"]})

    call popup_hide(s:popup_id)
    call setbufvar(winbufnr(s:popup_id), '&filetype', 'which_key')
    call win_execute(s:popup_id, 'setlocal nonumber nowrap')
  endif

  let rows = s:append_prompt(a:rows)
  let offset = s:floating_win_col_offset()
  if g:which_key_floating_relative_win
    let col = offset + win_screenpos(g:which_key_origin_winid)[1] + 1
    let maxwidth = winwidth(g:which_key_origin_winid) - offset
  else
    let col = offset + 1
    let maxwidth = &columns - offset
  endif
  call popup_move(s:popup_id, {
          \ 'col': col,
          \ 'line': &lines - len(rows) - &cmdheight,
          \ 'maxwidth': maxwidth,
          \ 'minwidth': maxwidth,
          \ })
  call popup_settext(s:popup_id, rows)
  call popup_show(s:popup_id)
endfunction

function! s:show_old_win(rows, layout) abort
  if s:winnr == -1
    call s:open_split_win()
  endif

  let resize = g:which_key_vertical ? 'vertical resize' : 'resize'
  noautocmd execute resize a:layout.win_dim
  setlocal modifiable
  " Delete all lines in the buffer
  " Use black hole register to avoid affecting the normal registers. :h quote_
  silent 1,$delete _
  call setline(1, a:rows)
  setlocal nomodifiable
endfunction

function! which_key#window#show(runtime) abort
  let s:name = get(a:runtime, 'name', '')
  let [layout, rows] = which_key#renderer#prepare(a:runtime)

  call s:show_popup(rows)
  call which_key#wait_for_input()
endfunction

function! which_key#window#close() abort
  if exists('s:origin_lnum_width')
    unlet s:origin_lnum_width
  endif

    call popup_close(s:popup_id)
    unlet s:popup_id
endfunction

function! which_key#window#name() abort
  return get(s:, 'name', '')
endfunction
