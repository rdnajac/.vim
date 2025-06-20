function! cd#smart() abort
  let l:dir = expand('%:p:h')
  if l:dir ==# getcwd()
    if has('nvim')
      let l:dir = luaeval("Snacks.git.get_root()")
    else
      let l:dir = substitute(system('git rev-parse --show-toplevel'), '\n', '', 'g')
    endif
  endif
  if !empty(l:dir)
    execute 'cd' fnameescape(l:dir)
  endif
  pwd
endfunction
