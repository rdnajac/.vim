" autoload/plug.vim; overrides `https://junegunn.github.io/vim-plug/`
if exists('g:loaded_plug') || !has('nvim')
  finish
endif
let g:loaded_plug = 0
let g:loaded_node_provider = 0
let g:loaded_perl_provider = 0
let g:loaded_ruby_provider = 0
let g:loaded_python3_provider = 0
let g:plug#home = stdpath('data')..'/site/pack/core/opt'
let $PACKDIR = g:plug#home " INFO: press `gf` on `$PACKDIR`

function! plug#begin(...)
  let g:plugs = []
  command! -nargs=+ -bar Plug call plug#(<args>)
endfunction

function! plug#(plugin, ...) abort
  let opts = a:0 > 0 ? a:1 : {} " TODO: handle opts...
  call add(g:plugs, a:plugin)
endfunction

function! plug#end()
  delcommand Plug
    command! PlugClean  :packdel ++all
    command! PlugStatus :packupdate ++offline
    command! -bang PlugUpdate packupdate<bang>
    lua vim.pack.add(vim.tbl_map(vim.fn['git#repo'], vim.g.plugs))
endfunction
