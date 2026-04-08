if !has('nvim')
  let s:jetpath = '~/.vim/pack/jetpack/opt/vim-jetpack/plugin/jetpack.vim'
  if !filereadable(expand(s:jetpath))
    execute printf('!curl -fLo %s --create-dirs %s', s:jetpath,
	  \ 'https://raw.githubusercontent.com/tani/vim-jetpack/master/plugin/jetpack.vim')
    packadd vim-jetpack
  endif
  let g:plug#home = expand('~/.vim/pack/jetpack')
else
  let g:plug#home = stdpath('data') .. '/site/pack/core/opt'
endif

let $PACKDIR = g:plug#home

function! plug#begin(...)
  if !exists('g:loaded_jetpack')
    let s:plugs = []
    command! -nargs=1 Plug call plug#(<args>)
  else
    call jetpack#begin()
    call jetpack#add('tani/vim-jetpack')
    command! -nargs=+ -bar Plug call jetpack#add(<args>)
  endif
endfunction

function! plug#(user_repo)
  call add(s:plugs, 'https://github.com/'..a:user_repo..'.git')
endfunction

function! plug#end()
  delcommand Plug
  if !exists('g:loaded_jetpack')
    if has('nvim')
      " relies on the magic `vim.g` accessor
      " lua vim.pack.add(vim.g.plugs)
      " passes script-local variable to lua via `_A`
      call luaeval('vim.pack.add(_A)', s:plugs)
      " lua require('plug')
      " execute 'source' expand('<script>:p:h:h')..'/lua/plug.lua'
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
