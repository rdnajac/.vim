function! plug#reload#() abort
  let l:old = g:plug_list
  let l:new = g:plug#list
  let l:removed = filter(copy(l:old), {_, v -> index(l:new, v) == -1})
  let l:added = filter(copy(l:new), {_, v -> index(l:old, v) == -1})
  if !empty(l:removed)
    Warn 'Removed plugins: ' . join(l:removed, ', ')
    Info 'Execute `:PlugClean` to remove them? [y/n]'
    " TODO: this gets messed up with `ch=0`
    let l:answer = nr2char(getchar())
    if l:answer ==? 'y'
      PlugClean
    endif
  endif
  if !empty(l:added)
    Warn 'Added plugins: ' . join(l:added, ', ')
    Warn 'It is better to `:restart` nvim to install them.'
  endif
endfunction
