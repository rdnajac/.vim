function! s:floating_win_col_offset() abort
  return (&number ? strlen(line('$')) : 0) + (exists('&signcolumn') && &signcolumn ==# 'yes' ? 2 : 0)
endfunction

function! g:Popup(cmd, rows) abort
  if !exists('s:popup_id')
    let s:popup_id = popup_create('', {
          \ 'line': &lines - len(a:rows) - &cmdheight,
          \ 'col': s:floating_win_col_offset() + 1,
          \ 'maxwidth': &columns - s:floating_win_col_offset(),
          \ 'minwidth': &columns - s:floating_win_col_offset(),
          \ 'hidden': v:true,
	  \ 'title': ' ' . a:cmd . ' ', 
	  \ 'close': 'click',  
          \ 'border': [1, 1, 1, 1],
	  \ 'borderhighlight': ['String'],
          \ 'borderchars': ['─', '│', '─', '│', '╭', '╮', '╯', '╰'],
          \ })
    call win_execute(s:popup_id, 'setlocal nonumber nowrap')
  endif

  call popup_settext(s:popup_id, a:rows)
  call popup_show(s:popup_id)
endfunction

function! g:Popup_close() abort
  if exists('s:popup_id')
    call popup_close(s:popup_id)
    unlet s:popup_id
  endif
endfunction

" nnoremap <CR> :call g:Popup_close()<CR>

" Execute the current file and display the output in a popup window
function! VX()
    let cmd = './' . expand('%')
    call Popup(cmd, systemlist(cmd))
endfunction
" TODO turn this into a command with options

command! -nargs=0 VX call VX()

" ssh my-ec2 "bash -s" < % 

finish

" TODO do I want want?
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