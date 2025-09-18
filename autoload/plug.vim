if exists('g:loaded_plug')
  finish
endif
let g:loaded_plug = 2 " `junegunn/vim-plug` sets this to 1

function! plug#begin() abort
  let g:plug_list = []
  command! -nargs=+ -bar Plug call plug#(<args>)
endfunction

function! plug#(repo, ...) abort
  call add(g:plug_list, a:repo)
endfunction

""
" Finalize plugin system:
" First the Plug command is deleted to avoid conflicts. Then, if running in
" Neovim and there are plugins to install, they are added. Otherwise, syntax
" and filetype detection, plugins, and indenting are enabled
" using the guards copied from `tpope/vim-sensible`
" @public
function! plug#end() abort
  delcommand Plug
  if has('nvim')
    " return v:lua.require'nvim.plug'.end_()
   " lua nv.plug.end_()
   lua require('nvim.plug').end_()
  endif
  if !(exists('g:did_load_filetypes') 
	\ && exists('g:did_load_ftplugin')
	\ && exists('g:did_indent_on'))
    filetype plugin indent on
  endif
  if has('syntax') && !exists('g:syntax_on')
    syntax enable
  endif
endfunction
