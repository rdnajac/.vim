function vimline#active#statusline() abort
  " return nvim_get_current_win() == g:statusline_winid
  return win_getid() == g:statusline_winid
endfunction

" if exists('+winbar')
function vimline#active#winbar() abort
  return win_getid() == g:actual_curwin
endfunction
" endif
