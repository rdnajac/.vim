if !has('nvim')
  let s:jetpath = '~/.vim/pack/jetpack/opt/vim-jetpack/plugin/jetpack.vim'
  if !filereadable(expand(s:jetpath))
    execute printf('!curl -fLo %s --create-dirs ' .
	  \ 'https://raw.githubusercontent.com/tani/vim-jetpack/master/plugin/jetpack.vim',
	  \ s:jetpath)
    packadd vim-jetpack
  endif
  let g:plug#home = expand('~/.vim/pack/jetpack')
else
  " let g:plug#home = join([ stdpath('data'), 'site', 'pack', 'core', 'opt' ], '/')
  let g:plug#home = expand('~/.local/share/nvim/site/pack/core/opt')
endif

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
    if has('nvim')
      lua vim.loader.enable()
      lua vim.pack.add(vim.g.plugs)
    endif
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
