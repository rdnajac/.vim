set encoding=utf-8
scriptencoding utf-8
if !has('nvim')
  if &compatible | set nocompatible | endif
  set nolangremap		  " disable a legacy behavior that can break plugin maps
  filetype plugin indent on       " enable filetype detection, plugins, and indentation
  syntax enable                   " source $VIMRUNTIME/syntax/syntax.vim
  runtime! macros/matchit.vim     " enable % to match more than just parens
  runtime ftplugin/man.vim        " enable the :Man command shipped inside Vim
  silent! color scheme            " my colorscheme (in ~/.vim/colors/)
  " set up vim home directory {{{
  let s:VIMHOME = expand('$HOME/.vim/')
  set undofile swapfile backup
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
  " }}}
  set autoindent smarttab         " enable auto-indent and smart tabbing
  set autoread autowrite          " automatically read/write files when changed
  set backspace=indent,eol,start  " configure backspace behavior to be more intuitive
  set formatoptions+=j            " delete comment character when joining lines
  set formatoptions-=o            " don't continue comments when pressing 'o'
  set hidden                      " enable background buffers
  set hlsearch incsearch          " highlighted, incremental search
  set lazyredraw                  " don't redraw the screen while executing macros
  set mouse=a                     " wait, that's illegal
  set nomodeline                  " modelines are a security risk
  set nrformats-=octal		  " Ignore octal numbers for Ctrl-A and Ctrl-X
  "set path=.,,                    " C ftplugin should add '/usr/include'
  set shortmess+=A                " avoid 'hit-enter' prompts
  set shortmess-=S                " don't show search count
  set showcmd                     " show the command being typed
  set ruler
  set termguicolors
  set ttimeout ttimeoutlen=69	  " time out on mappings
  set wildmenu                    " just use the default wildmode
  " set path+=$HOME/.files/**
  " set path+=$HOME/.vim/**
  " set path+=$HOME/rdnajac/**
  set foldlevel=99		  " open all folds by default
else
  echom 'sourcing vimrc! >^.^<'
  "set runtimepath+=~/.vim/
  set pumblend=10
  let g:tmux_navigator_disable_netrw_workaround = 1
endif

set autochdir                     " change directory to the file being edited
set completeopt+=preview	  " show preview window
set completeopt=menuone,noselect  " show menu even if there's only one match
set cursorline                    " highlight the current line
set fillchars+=eob:\ ,		  " don't show end of buffer as a column of ~
set fillchars+=stl:\ ,            " display spaces properly in statusline
set fillchars=                    " reset fillchars
set ignorecase smartcase          " ignore case when searching, unless there's a capital letter
set linebreak breakindent         " break at word boundaries and indent
set listchars=trail:¿,tab:→\      " show trailing whitespace and tabs
set nowrap                        " don't wrap lines by default
set number relativenumber         " show (relative) line numbers
set numberwidth=3                 " line number column padding
set pumheight=10                  " limit the number of items in a popup menu
set report=0                      " display how many replacements were made
set scrolloff=5                   " default 0, set to 5 in defaults.vim
set shiftround			  " round indent to multiple of shiftwidth
set showmatch                     " highlight matching brackets
set splitbelow splitright         " where to open new splits by default
set timeoutlen=420		  " ms for a mapped sequence to complete
set updatetime=100                " used for CursorHold autocommands
set whichwrap+=<,>,[,],h,l        " wrap around newlines with these keys
set fillchars+=fold:\ ,foldopen:▾,foldclose:▸,foldsep:│
set foldmethod=marker		  " fold based on markers (default: {{{,}}})
set foldopen+=insert
set foldopen+=jump

" `iskeyword` is used for word motions, completion, etc.
set iskeyword+=_
if &filetype != 'vim' && expand('%:t') != 'vimrc'
  set iskeyword+=-
else
  set iskeyword-=-
endif

if system('uname') =~? '^darwin'
  set clipboard=unnamed
else
  set clipboard=unnamedplus
endif

" keymaps {{{1
let g:mapleader = ' '
let g:maplocalleader = ','

" paste without overwriting the clipboard
xnoremap <silent> p "_dP

vnoremap <C-s> :sort<CR>

nnoremap <leader>b :b <C-d>
nnoremap <leader>f :find<space>
nnoremap <leader>h :nohlsearch<CR>
nnoremap <leader>i :execute 'verbose set '.expand("<cword>")<CR>
nnoremap <leader>q :call SmartQuit()<CR>
nnoremap <leader>r :source $MYVIMRC<CR>
" nnoremap <leader>t :TTags<space>*<space>*<space>.<CR>

nnoremap <leader>t :execute "e " . expand("~/.vim/after/ftplugin/") . &filetype . ".vim"<CR>
nnoremap <leader>v :e $MYVIMRC<CR>
nnoremap <leader>w :w<CR>
nnoremap <leader>x :!./%<CR>

" buffer/window navigation {{{2
nnoremap <tab> :bnext<CR>
nnoremap <s-tab> :bprevious<CR>
nnoremap <leader><tab> :b#<CR>

" better escape with jk/kj {{{2
inoremap jk <esc>
inoremap kj <esc>
vnoremap jk <esc>
vnoremap kj <esc>

" toggle settings {{{2
nnoremap <leader>sl :set list!<CR>:set list?<CR>
nnoremap <leader>sn :set nornu number!<CR>:set number?<CR>
nnoremap <leader>sr :set relativenumber!<CR>:set relativenumber?<CR>
nnoremap <leader>sw :set wrap!<CR>:set wrap?<CR>

function! s:toggle(opt, default)
  execute 'if &'.a:opt.' == '.a:default.' | '.'set '.a:opt.'=0 | '.'else | '.'set '.a:opt.'='.a:default.' | '.'endif '
endfunction

nnoremap <leader>st :call <SID>toggle('showtabline', 2)<CR>
nnoremap <leader>ss :call <SID>toggle('laststatus', 2)<CR>
nnoremap <leader>sc :call <SID>toggle('colorcolumn', 81)<CR>

" indent/dedent in normal mode with < and > {{{2
nnoremap > V`]>
nnoremap < V`]<

" move lines up and down {{{2
nnoremap - ddpkj
nnoremap _ kddpk
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

" better completion {{{2
inoremap <silent> <localleader>o <C-x><C-o>
inoremap <silent> <localleader>f <C-x><C-f>
inoremap <silent> <localleader>i <C-x><C-i>
inoremap <silent> <localleader>l <C-x><C-l>
inoremap <silent> <localleader>n <C-x><C-n>
inoremap <silent> <localleader>t <C-x><C-]>
inoremap <silent> <localleader>u <C-x><C-u>

" easy command line! {{{2
cnoreabbrev ?? verbose set?<Left>
cnoreabbrev !! !./%

" center searches {{{2
nnoremap n nzzzv
nnoremap N Nzzzv
nnoremap * *zzzv
nnoremap # #zzzv
nnoremap g* g*zzzv
nnoremap g# g#zzzv

" unmappings {{{2
" no Ex mode
nnoremap Q <nop>
" TODO make Q format?
" avoid conflicts with tmux
nnoremap <C-f> <nop>

" easy ftplugin configuration {{{1
augroup vimrc
  autocmd!
  autocmd FileType c            setlocal sw=8 sts=8 noexpandtab
  autocmd FileType cpp,python   setlocal sw=4 sts=4 fdm=syntax fdl=9 expandtab
  " autocmd FileType cpp		setlocal fo-=cro
  autocmd FileType tex          setlocal sw=2 sts=2 fdm=syntax fdl=9 spell
  autocmd FileType vim,lua      setlocal sw=2 sts=2 fdm=marker
  autocmd FileType sh	        setlocal sw=8 sts=8 noexpandtab wrap 
  autocmd CmdwinEnter * quit
augroup END

augroup fixsyntax
  autocmd!
  " force syntax highlighting for html template files
  autocmd BufNewFile,BufRead *.html set filetype=html
  " vim gets confused if these are not prefixed with a dot
  autocmd BufNewFile,BufRead bash_aliases set filetype=sh
  autocmd BufNewFile,BufRead gitconfig set filetype=gitconfig
augroup END
" }}}

" automatically downloads vim-plug to your machine if not found {{{2
" https://cs4118.github.io/dev-guides/vim-workflow.html
if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    exec 'autocmd VimEnter * PlugInstall --sync | source $MYVIMRC'
endif
" }}}
"
call plug#begin('~/.vim/.plugged')
Plug 'tpope/vim-apathy'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-vinegar'
Plug 'tpope/vim-scriptease'
Plug 'tpope/vim-repeat'
Plug 'godlygeek/tabular'
Plug 'wellle/targets.vim'
Plug 'lervag/vimtex'
Plug 'flwyd/vim-conjoin'
Plug 'jiangmiao/auto-pairs'
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && npx --yes yarn install' }
Plug 'machakann/vim-highlightedyank'
Plug 'github/copilot.vim'
Plug 'dense-analysis/ale'
Plug 'ycm-core/YouCompleteMe'
Plug 'ervandew/supertab'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
call plug#end()

let g:tex_flavor                = 'latex'
let g:is_bash                   = 1
let g:vimtex_view_method        = 'skim'
let g:copilot_workspace_folders = ['~/.vim', '~/.files', '~/rdnajac']
let g:copilot_no_tab_map = v:true
imap <silent><script><expr> <c-j> copilot#Accept("\<C-j>")

" vim: ft=vim fdm=marker fdl=2 sw=2 sts=2
