" sessions, restarts, and project-specific tabs

" Disable saving of irrelevant options in sessions
set sessionoptions-=options   " already default in nvim
set sessionoptions-=blank     " like vim-obsession
set sessionoptions-=tabpages  " per project, not global
set sessionoptions-=terminal  " don't save terminals

" Keep mkview minimal
set viewoptions-=options

" --- Helpers ---
" Find the root of the Git repository, or return current working directory.
function! s:git_root() abort
  let l:root = system('git rev-parse --show-toplevel 2>/dev/null')
  if v:shell_error
    return getcwd()
  endif
  return substitute(l:root, '\n\+$', '', '')
endfunction

" Try to load a session.vim if it exists in the project root.
function! s:maybe_load_session() abort
  let l:root = s:git_root()
  let l:session = l:root . '/session.vim'
  if filereadable(l:session)
    " Open a new tab for this project and source its session
    tabnew
    execute 'silent! source ' . fnameescape(l:session)
  endif
endfunction

" --- Restart logic ---
" Save the current session and restart Neovim (or reload in Vim).
function! s:restart() abort
  if has('nvim')
    let l:sesh = fnameescape(stdpath('state') . '/Session.vim')
    execute 'mksession! ' . l:sesh
    let l:cmd = 'silent! source ' . l:sesh
    execute 'confirm restart ' . l:cmd
  else
    " crude reload fallback
    source $MYVIMRC
  endif
endfunction

" --- Commands ---
command! Restart call s:restart()
command! ProjectSession call s:maybe_load_session()

" Auto-load session.vim for the current project on startup
augroup ProjectSessions
  autocmd!
  autocmd VimEnter * call s:maybe_load_session()
augroup END
