" sessions, restarts, and project-specific tabs

" Disable saving of irrelevant options in sessions
set sessionoptions-=options   " already default in nvim
set sessionoptions-=blank     " like vim-obsession
set sessionoptions-=tabpages  " per project, not global
set sessionoptions-=terminal  " don't save terminals

set viewoptions-=options      " keep mkview minimal

finish " WIP
command! ProjectSession call sesh#maybe_load_session()

augroup ProjectSessions
  autocmd!
  autocmd VimEnter * ProjectSessionaugroup
augroup END
