" see `:h vim.pack-directory`
let g:plug#home = stdpath('data') .. '/site/pack/core/opt'

" export the ENV variable
let $PACKDIR = g:plug#home

augroup plug.nvim
  autocmd!
  " autocmd PackChanged * call luaeval("require('plug.build')({ data = _A })", deepcopy(v:event))
augroup END

" `https://junegunn.github.io/vim-plug/`
function! plug#begin(...)
  let g:plugs = []
  command! -nargs=1 Plug call plug#(<args>)
endfunction

function! plug#(user_repo)
  call add(g:plugs, 'https://github.com/'..a:user_repo..'.git')
endfunction

function! plug#end()
  delcommand Plug
  lua vim.pack.add(vim.g.plugs)
  lua require('plug')
endfunction
