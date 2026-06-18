" autoload/plug.vim; overrides `https://junegunn.github.io/vim-plug/`
if exists('g:loaded_plug')
  finish
endif
let g:loaded_plug = v:true

packadd! cfilter
if !has('nvim')
  packadd! comment
  packadd! editorconfig
  packadd! hlyank
  call vim#sensible#()
else
  let g:plug#home = stdpath('data')..'/site/pack/core/opt'
  let $PACKDIR = g:plug#home " NOTE: press `gf` on `$PACKDIR`

  let g:loaded_node_provider = 0
  let g:loaded_perl_provider = 0
  let g:loaded_python3_provider = 0
  let g:loaded_ruby_provider = 0

  packadd! nvim.difftool
  packadd! nvim.tohtml
  packadd! nvim.undotree
endif

function! plug#begin(...)
  let g:plugs = []
  " command -nargs=1 -bang Plug call add(g:plugs, <args>)
  command! -nargs=+ -bar Plug call s:snackpack_add(<args>)
endfunction

function! s:snackpack_add(plugin, ...) abort
  let opts = a:0 > 0 ? a:1 : {} " TODO: handle opts
  call add(g:plugs, a:plugin)
endfunction

function! plug#end()
  delcommand Plug
  if has('nvim')
    command! PlugStatus :packu ++offline
    command! PlugClean  :packd ++all
  endif
endfunction
