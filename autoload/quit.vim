" TODO: remove me
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

" TODO: remove me
function! quit#oldversion() abort
  if winnr('$') > 1
    bnext | 1wincmd w | q!
  else
    if len(filter(range(1, bufnr('$')), 'buflisted(v:val)')) > 1
      bnext | bd# | 1wincmd w
    else
      quit!
    endif
  endif
endfunction
