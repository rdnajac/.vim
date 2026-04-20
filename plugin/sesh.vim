set sessionoptions-=blank
set sessionoptions-=folds
set sessionoptions-=terminal

if has('nvim')
  " restart neovim and restore state with Session
  function s:restart() abort
    execute 'mks!' stdpath('state')..'/Session.vim'
    execute 'conf restart sil so' v:this_session
  endfunction

  nnoremap ZR <Cmd>call <SID>restart()<CR>
  command! Restart call s:restart()
  nnoremap <D-r> <Cmd>Restart<CR>
endif
