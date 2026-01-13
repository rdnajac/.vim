function! plug#begin(...)
  if !exists('g:loaded_jetpack')
    let g:plugs = []
    command! -nargs=1 Plug call add(g:plugs, git#repo(<args>))
    " command! -nargs=+ -bar Plug call luaeval("require('plug').add(_A)", <args>)
  else
    call jetpack#begin()
    call jetpack#add('tani/vim-jetpack')
    command! -nargs=+ -bar Plug call jetpack#add(<args>)
  endif
endfunction

function! plug#end()
  delcommand Plug
  if !exists('g:loaded_jetpack')
    lua vim.pack.add(vim.g.plugs)
  else
    call jetpack#end()
    for name in jetpack#names()
      if !jetpack#tap(name)
	call jetpack#sync()
	break
      endif
    endfor
  endif
endfunction
