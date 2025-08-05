set backspace=indent,eol,start
set complete-=i
set display+=lastline
set formatoptions+=j
set incsearch
set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+
set nrformats-=octal
set smarttab

" Persist g:UPPERCASE variables, used by some plugins, in .viminfo.
if !empty(&viminfo)
  set viminfo^=!
endif

" clear the highlighting of 'hlsearch' (off by default) and call :diffupdate.
nnoremap <silent> <C-L> :nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><C-L>

" Replace the check for a tags file in the parent directory of the current
" file with a check in every ancestor directory.
if has('path_extra') && (',' . &g:tags . ',') =~# ',\./tags,'
  setglobal tags-=./tags tags-=./tags; tags^=./tags;
endif


" Disable a legacy behavior that can break plugin maps.
set nolangremap

inoremap <C-U> <C-G>u<C-U>
inoremap <C-W> <C-G>u<C-W>

" Load matchit.vim, but only if the user hasn't installed a newer version.
if !exists('g:loaded_matchit') && findfile('plugin/matchit.vim', &rtp) ==# ''
  runtime! macros/matchit.vim
endif

" Enable the :Man command shipped inside Vim's man filetype plugin.
if exists(':Man') != 2 && !exists('g:loaded_man') && &filetype !=? 'man' && !has('nvim')
  runtime ftplugin/man.vim
endif
