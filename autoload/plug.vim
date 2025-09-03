if exists('g:loaded_plug')
  finish
endif
let g:loaded_plug = 2 " `junegunn/vim-plug` sets this to 1

""
" Initialize plugin system
function! plug#begin() abort
  " lua require('plug').begin()
  command! -nargs=+ -bar Plug call luaeval("require('plug')(_A)", split(<args>))
endfunction

""
" Finalize plugin system:
" First the Plug command is deleted to avoid conflicts. Then, if running in
" Neovim and there are plugins to install, they are added. Otherwise, syntax
" and filetype detection, plugins, and indenting are enabled
" using the guards copied from `tpope/vim-sensible`
" @public
function! plug#end() abort
  " delcommand Plug
  if has('nvim')
    lua require('plug').end_()
  else
    if !(exists('g:did_load_filetypes')
	  \ && exists('g:did_load_ftplugin')
	  \ && exists('g:did_indent_on'))
      filetype plugin indent on
    endif
    if has('syntax') && !exists('g:syntax_on')
      syntax enable
    endif
  endif
endfunction
