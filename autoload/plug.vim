if exists('g:loaded_plug') || !has('nvim')
  finish
endif
let g:loaded_plug = v:true

function! plug#begin() abort
  let g:plugins = []
  command! -nargs=+ -bar Plug call plug#(<args>)
endfunction

function! plug#(repo, ...) abort
  " call add(g:plugins, a:repo)
  call add(g:plugins, 'http://github.com/'.a:repo.'.git')
endfunction

function! plug#end() abort
  delcommand Plug
  " lua vim.pack.add(vim.g.plugins)
endfunction
