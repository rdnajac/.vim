" Try to load a session.vim if it exists in the project root.
function! sesh#maybe_load_session() abort
  let l:root = git#root()
  let l:sesh = l:root . '/Session.vim'
  if filereadable(l:sesh)
    " Open a new tab for this project and source its session
    tabnew
    execute 'silent! source ' . fnameescape(l:sesh)
  endif
endfunction

function! sesh#restart() abort
  if has('nvim')
    let l:sesh = fnameescape(stdpath('state') . '/Session.vim')
    execute 'mksession! ' . l:sesh
    let l:cmd = 'silent! source ' . l:sesh
    execute 'confirm restart ' . l:cmd
  endif
endfunction
