" ~/.vim/autoload/plug.vim
let g:plugins = []

function! s:plug(repo)
  let repo = a:repo
  if repo[0] ==# "'" && repo[-1:] ==# "'"
    let repo = repo[1:-2]
  endif
  call add(g:plugins, 'https://github.com/' . repo)
endfunction

function! plug#begin()
  let g:plugins = []
  command! -nargs=1 -bar Plug call s:plug(<f-args>)
endfunction

function! plug#end()
  delcommand Plug
  " TODO: add opts {load = false}
  call luaeval('vim.pack.add(_A, {load = false})', g:plugins)
endfunction
