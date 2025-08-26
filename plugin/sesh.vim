" sessions, restarts, and more
" Saving options in session and view files causes more problems than it
" solves, so disable it.
set sessionoptions-=options " default in nvim
set sessionoptions-=blank " from vim-obsession
" keep tabpages separate (per project)
set sessionoptions-=tabpages

" viewoptions change the effect of the `:mkview`
set viewoptions-=options " from defaults.vim

""
" @section(session)
" @function(s:restart)
" Save the current session and restart Neovim. In Vim, reload all scripts.
"
" This function will:
" 1. Save the current session to {stdpath('state')}/Session.vim.
" 2. Prompt the user to confirm restart with :confirm.
" 3. Reload the saved session after restart.
function! s:restart() abort
  if has('nvim')
    let sesh = fnameescape(stdpath('state') . '/Session.vim')
    execute 'mksession! ' . sesh
    let cmd = 'silent! source ' . sesh
    execute 'confirm restart ' cmd
  else
    call reload#()
  endif
endfunction


""
" @section(commands)
" @command(Restart)
" Saves the session and restarts the editor.
command! Restart call s:restart()
