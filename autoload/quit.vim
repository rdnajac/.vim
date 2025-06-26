function! quit#buffer(bang) abort
  let l:bufs = filter(range(1, bufnr('$')), 'bufexists(v:val) && buflisted(v:val)')

if &modified
  let path = expand('%:p')
  let in_data = path =~# '^' . stdpath('data')
  let in_plug = exists('g:plug_home') && path =~# '^' . g:plug_home
  if !in_data && !in_plug
    noautocmd write!
  endif

endif
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
