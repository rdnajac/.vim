function! quit#buffer(bang) abort
  if a:bang == ''
    execute 'bdelete'
  elseif has('nvim')
    call v:lua.Snacks.bufdelete()
  else
    let l:bufs = filter(getbufinfo({'buflisted':1}), 'v:val.bufnr != bufnr("")')
    if !empty(l:bufs)
      if empty(a:bang) && getbufvar('%', '&modified')
	echohl WarningMsg
	echom 'No write since last change for buffer '.bufnr('%').' (use :Bclose!)'
	echohl None
	return
      endif
      let l:btarget = bufnr('%')
      let l:wcurrent = winnr()
      execute ':confirm :bdelete '.l:btarget
      execute l:wcurrent.'wincmd w'
    else
      quit
    endif
  endif
endfunction
