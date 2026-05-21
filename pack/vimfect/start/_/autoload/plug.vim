" see `:h vim.pack-directory`
if exists('*stdpath')
  let g:plug#home = stdpath('data') .. '/site/pack/core/opt'
else
  let g:plug#home = expand('~/.vim/pack/_/opt')
endif

" export the ENV variable
let $PACKDIR = g:plug#home

augroup plug.nvim
  autocmd!
  " autocmd PackChanged * call luaeval("require('plug.build')({ data = _A })", deepcopy(v:event))
augroup END

" `https://junegunn.github.io/vim-plug/`
function! plug#begin(...)
  let g:plugs = []
  command! -nargs=1 Plug call add(g:plugs, <args>)
endfunction

" function! plug#(user_repo)
  " call add(g:plugs, 'https://github.com/'..a:user_repo..'.git')
" endfunction

function! plug#end()
  delcommand Plug
  if has('nvim')
    lua require('plug')(vim.g.plugs)
    command! PlugStatus :packupdate ++offline
    command! PlugClean  :packdel    ++all 
  endif
endfunction
