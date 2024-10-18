" vimrc
set encoding=utf-8
scriptencoding utf-8
" vint: -ProhibitSetNoCompatible
if &compatible | set nocompatible | endif
set nolangremap		        " disable a legacy behavior that can break plugin maps
filetype plugin indent on       " enable filetype detection, plugins, and indentation
syntax enable                   " source $VIMRUNTIME/syntax/syntax.vim
runtime! macros/matchit.vim     " enable % to match more than just parens
runtime ftplugin/man.vim        " enable the :Man command shipped inside Vim
silent! color scheme            " my colorscheme (in ~/.vim/colors/)

source $HOME/.vim/init.vim
source $HOME/.vim/init/keys.vim " key mappings
source $HOME/.vim/init/plug.vim " plugins from vim-plug

" configure the home directory, undo, swap, backup, and info files
set undofile swapfile backup
let s:VIMHOME = expand('$HOME/.vim/')
let &undodir     = s:VIMHOME . '.undo//'
let &directory   = s:VIMHOME . '.swap//'
let &backupdir   = s:VIMHOME . '.backup//'
let &viminfofile = s:VIMHOME . '.viminfo'
let &spellfile   = s:VIMHOME . '.spell/en.utf-8.add'
" let &verbosefile = s:VIMHOME . '.vimlog.txt'
" set viminfo=
if !isdirectory(&undodir)   | call mkdir(&undodir,   'p', 0700) | endif
if !isdirectory(&directory) | call mkdir(&directory, 'p', 0700) | endif
if !isdirectory(&backupdir) | call mkdir(&backupdir, 'p', 0700) | endif

" these settings are default in neovim
set autoindent smarttab	        " enable auto-indent and smart tabbing
set autoread autowrite          " automatically read/write files when changed
set backspace=indent,eol,start  " configure backspace behavior to be more intuitive
set hidden                      " enable background buffers
set hlsearch incsearch          " highlighted, incremental search
set lazyredraw                  " don't redraw the screen while executing macros
set mouse=a                     " wait, that's illegal
set nomodeline                  " modelines are a security risk
set nrformats-=octal		" ignore octal numbers for Ctrl-A and Ctrl-X
set shortmess+=A                " avoid 'hit-enter' prompts
set shortmess-=S                " don't show search count
set showcmd                     " show the command being typed
set ruler                       " show the cursor position all the time
set termguicolors               " enable true colors in the terminal
set ttimeout ttimeoutlen=69	" time out on mappings
set wildmenu                    " just use the default wildmode
set foldlevel=99                " open all folds by default

augroup myftplugin
  autocmd!
  autocmd FileType c            setlocal sw=8 sts=8 noexpandtab
  autocmd FileType cpp,python   setlocal sw=4 sts=4   expandtab
  autocmd FileType python       setlocal sw=4 sts=4   expandtab fdm=indent
  autocmd FileType sh	        setlocal sw=8 sts=8 noexpandtab wrap
  autocmd FileType tex          setlocal sw=2 sts=2 fdm=syntax  spell
  autocmd FileType vim,lua      setlocal sw=2 sts=2 fdm=marker
  autocmd FileType * setlocal formatoptions+=j
  autocmd FileType * setlocal formatoptions-=o
  autocmd CmdwinEnter * quit
augroup END

let g:tex_flavor                = 'latex'
let g:is_bash                   = 1
let g:vimtex_view_method        = 'skim'
let g:copilot_workspace_folders = ['~/.vim', '~/.files', '~/rdnajac']
let g:copilot_no_tab_map = v:true
imap <silent><script><expr> <c-j> copilot#Accept("\<C-j>")

" vim: ft=vim fdm=marker fdl=1 sw=2 sts=2 expandtab
