if exists('g:loaded_plug')
  finish
endif
let g:loaded_plug = 2 " `junegunn/vim-plug` sets this to 1

function! plug#begin() abort
  let g:plug#list = [] " script-local list
  command! -nargs=+ -bar Plug call plug#(<args>)
endfunction

function! plug#(repo, ...) abort
  call add(g:plug#list, a:repo)
endfunction

function! plug#end() abort
  if exists('g:loaded_vimrc')
    let g:loaded_vimrc += 1
    Info 'Reloaded vimrc [' . g:loaded_vimrc . ']'
  elseif has('nvim')
    delcommand Plug
    if !exists('g:plug_list')
      let g:plug_list = deepcopy(g:plug#list)
    elseif len(g:plug_list) > len(g:plug#list)
      Warn "different number of plugins"
      PlugClean
    endif
    lua require('nvim.plug').end_()
  else
    if !(exists('g:did_load_filetypes')
	  \ && exists('g:did_load_ftplugin')
	  \ && exists('g:did_indent_on')
	  \ )
      filetype plugin indent on
    endif
    if has('syntax') && !exists('g:syntax_on')
      syntax enable
    endif
  endif
endfunction
