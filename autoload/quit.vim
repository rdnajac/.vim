function! quit#buffer(bang) abort
  let l:bufs = filter(range(1, bufnr('$')), 'bufexists(v:val) && buflisted(v:val)')

  if len(l:bufs) <= 1
    quit!
  else
    if has('nvim')
      if a:bang == ''
	call v:lua.Snacks.bufdelete()
      else
	execute 'bdelete!'
      endif
    else
      execute ':confirm bdelete ' . bufnr('%')
      execute winnr() . 'wincmd w'
    endif
  endif
endfunction
