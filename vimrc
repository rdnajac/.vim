" vimrc
set encoding=utf-8
scriptencoding utf-8
" vint: -ProhibitSetNoCompatible
if &compatible | set nocompatible | endif
set nolangremap		        " disable a legacy behavior that can break plugin maps
runtime! macros/matchit.vim     " enable % to match more than just parens
runtime ftplugin/man.vim        " enable the :Man command shipped inside Vim
color scheme

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

if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

call plug#begin('~/.vim/.plugged')
Plug 'tpope/vim-apathy'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-scriptease'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-vinegar'
Plug 'godlygeek/tabular'
Plug 'wellle/targets.vim'
" Plug 'lervag/vimtex'
Plug 'flwyd/vim-conjoin'
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && npx --yes yarn install' }
Plug 'machakann/vim-highlightedyank'
Plug 'github/copilot.vim'
Plug 'dense-analysis/ale'
Plug 'ycm-core/YouCompleteMe', { 'do': './install.py --clangd-completer' }
call plug#end()

let g:is_bash = 1
let g:tex_flavor = 'latex'
" let g:vimtex_view_method = 'skim'

" copilot settings
let g:copilot_workspace_folders = ['~/.vim', '~/.files']
let g:copilot_no_tab_map = v:true
imap <silent><script><expr> <c-j> copilot#Accept("\<C-j>")
" vim: ft=vim fdm=marker fdl=1 sw=2 sts=2 expandtab
