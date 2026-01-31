function! s:diffthese() abort
  diffthis | wincmd p |diffthis
endfunction

if exists(':DiffOrig') != 2
  command DiffOrig vnew +set\ bt=nofile | r ++edit # | 0d_ | call s:diffthese()
endif

function! cmd#diff#(...) abort
  let l:winnr = winnr('$')

  if a:0 == 0
    if l:winnr == 1
      DiffOrig
    elseif winnr('$') == 2
      if exists(':DiffTool') == 2
	let b1 = fnamemodify(bufname(winbufnr(1)), ':p')
	let b2 = fnamemodify(bufname(winbufnr(2)), ':p')
	echom 'Using DiffTool to compare: ' . b1 . ' and ' . b2
	execute 'DiffTool' b1 b2
      else
	call s:diffthese()
      endif
    else
      echoerr 'Exactly two windows must be open.'
    endif

  elseif a:0 == 1
    if l:winnr == 1
      execute 'vert sbuffer' a:1
      call s:diffthese()
    endif

  elseif a:0 == 2
    let bufnr1 = a:1
    let bufnr2 = a:2
    let abspath1 = fnamemodify(bufname(bufnr1), ':p')
    let abspath2 = fnamemodify(bufname(bufnr2), ':p')
    execute 'DiffTool' abspath1 abspath2
  endif
endfunction
