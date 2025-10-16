if exists('g:loaded_plug')
  finish
endif

let g:loaded_plug = v:true

function! plug#begin() abort
  Warn 'inside plug#begin'
  let g:plugs = []
  command! -nargs=+ -bar Plug call plug#(<args>)
endfunction

function! plug#(repo, ...) abort
  " call add(g:plugs, a:repo)
  call add(g:plugs, 'http://github.com/'.a:repo.'.git')
endfunction

function! plug#end() abort
  delcommand Plug
  " lua vim.pack.add(vim.g.plugs)
endfunction
