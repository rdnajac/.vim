if exists('g:loaded_plug')
  finish
endif

let g:loaded_plug = 2 " `junegunn/vim-plug` sets this to 1
let g:plug_home = join([stdpath('data'), 'site', 'pack', 'core', 'opt'], '/')

""
" Initialize plugin system
function! plug#begin() abort
  let g:plugins = []
  command! -nargs=+ -bar Plug call plug#(<args>)
endfunction

""
" Add a plugin to the list
function! plug#(repo) abort
  let l:repo = 'https://github.com/' . trim(a:repo) . '.git'
  call add(g:plugins, l:repo)
endfunction

""
" Finalize plugin system
function! plug#end() abort
  delcommand Plug
  if has('nvim')
    if !empty(g:plugins)
      lua vim.pack.add(vim.g.plugins, { confirm = false })
    endif
  else
    " from `tpope/vim-sensible`
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
