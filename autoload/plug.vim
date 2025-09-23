if exists('g:loaded_plug')
  finish
endif
let g:loaded_plug = 2 " `junegunn/vim-plug` sets this to 1

function! plug#begin() abort
  if exists('g:plug#list')
    let g:plug#cache = deepcopy(g:plug#list)
  endif
  let g:plug#list = [] " TODO: script-local list
  command! -nargs=+ -bar Plug call plug#(<args>)
  " if we're on vim, there still time to curl the plug.vim file and source
  " it; need to ensuer plug#begin behaves correctly since we probably won't
  " get another chance to call it unless we do something funky with autocmds?
endfunction

function! plug#(repo, ...) abort
  " call add(g:plug#list, a:repo)
  call add(g:plug#list, 'http://github.com/' . a:repo . '.git')
endfunction

function! plug#end() abort
  if has('nvim')
    delcommand Plug
    " if exists('g:plug#cache')
    "   Warn "plug# reloaded!"
    "   call plug#reload#()
    " endif
    lua vim.pack.add(vim.g['plug#list'])
  else
    " TODO: move this to vim/sensible.vim
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
