" autoload/plug.vim
" overrides `https://junegunn.github.io/vim-plug/`
if !has('nvim')
  finish
endif

" see `:h vim.pack-directory`
let g:plug#home = stdpath('data')..'/site/pack/core/opt'
let $PACKDIR = g:plug#home " export the ENV variable

augroup plug.nvim
  autocmd!
  " autocmd PackChanged * call luaeval("require('plug.build')({ data = _A })", deepcopy(v:event))
augroup END

function! plug#begin(...)
  let g:plugs = []
  command! -nargs=1 -bang Plug call plug#(<args>, "<bang>" == "!")
endfunction

function! plug#(user_repo, ...)
  let bang = a:0 > 0 && a:1
  if bang
    call luaeval('vim.pack.add({ _A })', git#repo(a:user_repo))
    if v:vim_did_enter == 0
      exe 'packadd' fnamemodify(a:user_repo, ':t')
    endif
  else
    call add(g:plugs, a:user_repo)
  endif
endfunction

function! plug#end()
  delcommand Plug
  command! PlugStatus :packupdate ++offline
  command! PlugClean  :packdel    ++all
  lua require('plug')(vim.g.plugs)
endfunction
