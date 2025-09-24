" https://github.com/tpope/vim-sensible
" also see `:h defaults.vim` and `$VIMRUNTIME/defaults.vim`
function! vim#sensible#() abort
  set autoread
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

  " Disable a legacy behavior that can break plugin maps.
  set nolangremap

  " Replace the check for a tags file in the parent directory of the current
  " file with a check in every ancestor directory.
  if has('path_extra') && (',' . &g:tags . ',') =~# ',\./tags,'
    setglobal tags-=./tags tags-=./tags; tags^=./tags;
  endif

  " clear the highlighting of 'hlsearch' (off by default) and call :diffupdate.
  nnoremap <silent> <C-L> :nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><C-L>

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

  " `junegunn/vim-plug` will do these automatically
  if !exists('g:loaded_plug')
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
