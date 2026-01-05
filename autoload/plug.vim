if exists('g:loaded_jetpack')
  function! plug#begin(...)
    "   if exists('g:loaded_jetpack')
    call jetpack#begin()
    call jetpack#add('tani/vim-jetpack')
    command! -nargs=+ -bar Plug call jetpack#add(<args>)
  endfunction

  function! plug#end()
    delcommand Plug
    if exists('g:loaded_jetpack')
      call jetpack#end()
      for name in jetpack#names()
	if !jetpack#tap(name)
	  call jetpack#sync()
	  break
	endif
      endfor
    endif
  endfunction
endif
