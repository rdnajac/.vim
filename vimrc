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
  set path=.,,                    " C ftplugin should add '/usr/include'
  set shortmess+=A                " avoid 'hit-enter' prompts
  set shortmess-=S                " don't show search count
  set showcmd                     " show the command being typed
  set ruler
  set termguicolors
  set ttimeout ttimeoutlen=69	  " time out on mappings
  set wildmenu                    " just use the default wildmode
  set path+=$HOME/.files/**
  set path+=$HOME/.vim/**
  set path+=$HOME/rdnajac/**
else
  echom 'sourcing vimrc >^.^<'
  source $HOME/.vim/plugin/display/mystatusline.vim
  source $HOME/.vim/plugin/display/mytabline.vim
  set clipboard=unnamedplus     
  " can we set nvim-specefic options here?
  set pumblend=10
endif

" set cindent		   	  " should this be default?
set autochdir                     " change directory to the file being edited
" set breakindent                   " indent wrapped lines
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
" set nofoldenable                " don't fold by default; press 'zi' to toggle
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
" avoid conflicts with tmux
nnoremap <C-f> <nop>
" autocmds {{{1
augroup vimrc
  autocmd!
  " autocmd FileType 
  autocmd FileType c            setlocal sw=8 sts=8 noexpandtab
  autocmd FileType cpp,python   setlocal sw=4 sts=4 fdm=syntax fdl=9 expandtab
  autocmd FileType tex          setlocal sw=2 sts=2 fdm=syntax fdl=9 spell
  autocmd FileType vim	        setlocal sw=2 sts=2 fdm=marker
  autocmd FileType sh	        setlocal sw=8 sts=8 noexpandtab
  autocmd CmdwinEnter * quit            " close command-line window upon entering
  autocmd BufNewFile,BufRead bash_aliases set filetype=sh
  autocmd BufNewFile,BufRead *.html set filetype=html
augroup END

augroup RestoreCursor
  autocmd!
  autocmd BufReadPost *
	\ let line = line("'\"")
	\ | if line >= 1 && line <= line("$")
	\ |   execute "normal! g`\""
	\ |   execute "silent! normal! zO"
	\ | endif
augroup END
" }}}1
" extra syntax highlighting {{{
augroup StringInComments
    autocmd!
    autocmd Syntax * syntax region CommentBacktickString start=/`/ end=/`/ contained containedin=.*Comment
    autocmd Syntax * highlight link CommentBacktickString String
augroup END

highlight Evil guifg=red guibg=orange
match Evil /“\|”/
" }}}
" ignored files and directories {{{
set wildignore+=*.o,*.out,*.a,*.so,*.lib,*.bin,*/.git/*   " General build files
set wildignore+=*.pyo,*.pyd,*/.cache/*,*/dist/*           " Python files and directories
set wildignore+=*.swp,*.swo,*.tmp,*.temp                  " Swap and temporary files
set wildignore+=*.pdf,*.aux,*.fdb_latexmk,*.fls           " LaTeX files
set wildignore+=*.zip,*.tar.gz,*.rar,*.7z,*.tar.xz,*.tgz  " Archives and compressed files
set wildignore+=*.cmake,*.cmake.in,*.cmod,*/bin/*,*/build/* " C/C++ files and directories
set wildignore+=*/out/*,*/vendor/*,*/target/*,*/.vscode/*,*/.idea/*
set wildignore+=*.jpg,*.png,*.gif,*.bmp,*.tiff,*.ico,*.svg,*.webp,*.img
set wildignore+=*.mp*p4,*.avi,*.mkv,*.mov,*.flv,*.wmv,*.webm,*.m4v,*.flac,*.wav
set wildignore+=*.deb,*.rpm,*.dylib,*.app,*.dmg,*.DS_Store,*.exe,*.dll,*.msi,Thumbs.db
" }}}
" additional untested configs from LazyVim {{{
" https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
set grepformat="%f:%l:%c:%m"
set grepprg="rg --vimgrep"
set jumpoptions="view"
set splitkeep="screen"
set virtualedit="block"
" }}}
" vim: ft=vim fdm=marker sw=2 sts=2
