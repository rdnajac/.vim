" rdnajac's vimrc
" REMEMBER: CAPS LOCK MAPS TO CTRL 
if !has('nvim')  " {{{1
  " vim with a vimrc is always incompatible, but let's handle edge cases
  if &compatible | set nocompatible | endif                           

  " the following "sensible.vim" options have had their include guards removed
  set nolangremap		  " disable a legacy behavior that can break plugin maps
  filetype plugin indent on       " enable filetype detection, plugins, and indentation
  syntax enable                   " source $VIMRUNTIME/syntax/syntax.vim
  runtime! macros/matchit.vim     " enable % to match more than just parens
  runtime ftplugin/man.vim        " enable the :Man command shipped inside Vim
  silent! color scheme            " use my custom colorscheme (in ~/.vim/colors/)
  " set up vim home directory {{{3
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
  " }}}2
  set autoindent smarttab         " enable auto-indent and smart tabbing
  set autoread autowrite          " automatically read/write files when changed
  set backspace=indent,eol,start  " configure backspace behavior to be more intuitive
  set formatoptions+=j            " delete comment character when joining lines
  set formatoptions-=o            " don't continue comments when pressing 'o'
  set hidden                      " enable background buffers
  set hlsearch incsearch          " highlighted, incremental search
  set mouse=a                     " wait, that's illegal
  set nomodeline                  " modelines are a security risk
  set nrformats-=octal		  " Ignore octal numbers for Ctrl-A and Ctrl-X
  set path=.,,                    " C ftplugin should add "/usr/include"
  set shortmess+=A                " avoid 'hit-enter' prompts
  set shortmess-=S                " don't show search count
  set showcmd                     " show the command being typed
  set ruler
  set termguicolors
  set ttimeout ttimeoutlen=69	  " time out on mappings 
  set wildmenu                    " just use the default wildmode 
  " defaults.vim {{{2
  let c_comment_strings=1
  " CTRL-U in insert mode deletes a lot. Use CTRL-G u to first break undo,
  " so that you can undo CTRL-U after inserting a line break.
  inoremap <C-U> <C-G>u<C-U>
  " see the difference between current buffer and the file it was loaded from.
  if !exists(":DiffOrig")
    command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis | wincmd p | diffthis
  endif
  " }}}2
  set clipboard=unnamed
else
  set clipboard=unnamedplus     
endif

" other settings {{{1
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
set lazyredraw                    " don't redraw the screen while executing macros
set linebreak breakindent         " break at word boundaries and indent
set listchars=trail:¿,tab:→\      " show trailing whitespace and tabs
set nowrap                        " don't wrap lines by default
set number relativenumber         " show (relative) line numbers
set numberwidth=3                 " line number column padding
set path+=$HOME/.files/**
set path+=$HOME/.vim/**
set path+=$HOME/cbmf/**
set pumheight=10                  " limit the number of items in a popup menu
set report=0                      " display how many replacements were made
set scrolloff=5                   " default 0, set to 5 in defaults.vim
set shiftround			  " round indent to multiple of shiftwidth
set showmatch                     " highlight matching brackets
set splitbelow splitright         " where to open new splits by default
set timeoutlen=420		  " ms for a mapped sequence to complete
set updatetime=100                " used for CursorHold autocommands
set whichwrap+=<,>,[,],h,l        " wrap around newlines with these keys 

" fold settings {{{2
set fillchars+=fold:\ ,foldopen:▾,foldclose:▸,foldsep:│
set foldmethod=marker		  " fold based on markers (default: {{{,}}})
set foldopen+=insert
set foldopen+=jump
set nofoldenable                " don't fold by default; press 'zi' to toggle

" iskeyword {{{2
set iskeyword+=_ 
" if &filetype != 'vim' && expand('%:t') != 'vimrc'
"   set iskeyword+=-
" endif

" global variables {{{1
let g:copilot_workspace_folders = ["~/.vim", "~/.files", "~/cbmf"]
let g:is_bash                   = 1
let g:tex_flavor                = 'latex'
let g:vimtex_view_method        = 'skim'
let g:markdown_syntax_conceal   = 1
let g:markdown_folding	        = 1
let g:markdown_fenced_languages = ['bash=sh', 'c', 'python', 'vim']
let g:mapleader                 = ' '
let g:maplocalleader            = ','

" keymaps {{{1
" nnoremap <C-@> V:Twrite1<CR>
nnoremap <localleader>t0 V:Twrite0<CR>
nnoremap <localleader>t1 V:Twrite1<CR>
nnoremap <localleader>t2 V:Twrite2<CR>
nnoremap <localleader>t3 V:Twrite3<CR>

vnoremap <C-s> :sort<CR>
nnoremap <C-m> :Make<CR>

" double space over word to find and replace
nnoremap <Space><Space> :%s/\<<C-r>=expand("<cword>")<CR>\>/
vnoremap <Space><Space> y:%s/\<<C-r>=escape(@",'/\')<CR>\>/
" TODO why do we have < >

function! EXE(tmux_pane)
  " scp the current file to the remote server 
  " !scp % my-ec2:~/
  let cmd = '!scp % my-ec2:~/' 
  execute cmd
  let cmd = '!tmux send-keys -t ' . a:tmux_pane . ' "~/' . expand('$(basename %)') . '" Enter'
  execute cmd
endfunction

nnoremap <leader>b :b <C-d>
nnoremap <leader>c :call GetInfo()<CR>
nnoremap <leader>e :e!<CR>
nnoremap <leader>f :find<space>
nnoremap <leader>h :nohlsearch<CR>
nnoremap <leader>i :execute 'verbose set '.expand("<cword>")<CR>
nnoremap <leader>q :call utils#smartQuit()<CR>
nnoremap <leader>r :source $MYVIMRC<CR>
" nnoremap <leader>t :TTags<space>*<space>*<space>.<CR>
" edit ~/.vim
nnoremap <leader>t :execute "e " . expand("~/.vim/after/ftplugin/") . &filetype . ".vim"<CR>
nnoremap <leader>v :e $MYVIMRC<CR>
nnoremap <leader>w :w<CR>
nnoremap <leader>x :!./%<CR>
vnoremap <leader>r :<C-u>call utils#replaceSelection()<CR>

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
nnoremap <leader>sn :set number!<CR>:set number?<CR>
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

" command line abbreviations {{{2
cab wq  wqa!
cab Wq	wqa!
cab qW	wqa!
cab Qw	wqa!
cab WQ	wqa!
cab QW	wqa!
cab wqa wqa!
cab qwa wqa!

" fat fingers! {{{2
cnoreabbrev <expr> X getcmdtype() == ':' && getcmdline() == 'X' ? 'x' : 'X'
cnoreabbrev <expr> Q getcmdtype() == ':' && getcmdline() == 'Q' ? 'q' : 'Q'

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

" abbreviations {{{2
" ia <expr> ,lr strftime('LAST REVISION: ' . '%Y-%m-%d')
ia <expr> dt strftime('%Y-%m-%d')
ia <expr> tm strftime('%H:%M:%S')
ia <expr> dtm strftime('%Y-%m-%d %H:%M:%S')
ia LR LAST REVISION: <C-R>=strftime('%Y-%m-%d')<CR>
ia bb #!/bin/bash<CR>##<CR>##<space>
ia p3 #!/usr/bin/env python3<CR>
ia """ """<CR><CR>"""<Up>

" nnoremap <localleader>b i#!/bin/bash<CR>#<CR>#<space>

" unmappings {{{2
" no Ex mode
nnoremap Q <nop>
" avoid conflicts with tmux
nnoremap <C-f> <nop>

" autocmds {{{1
augroup vimrc
  autocmd!
  autocmd FileType cpp,python   setlocal sw=4 sts=4 fdm=syntax fdl=9 expandtab
  autocmd FileType tex          setlocal sw=2 sts=2 fdm=syntax fdl=9 spell
  autocmd FileType vim	        setlocal sw=2 sts=2 fdm=marker 
  autocmd CmdwinEnter * quit            " close command-line window upon entering
  "autocmd BufLeave {} bd!              " close buffer when leaving it
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

augroup SpecialBuffers
  autocmd!
  autocmd FileType help,qf,netrw,man
	\ silent! nnoremap <silent> <buffer> q :<C-U>close<CR> 
	\ | set nobuflisted
	\ | setlocal noruler
	\ | setlocal laststatus=0 
	\ | setlocal colorcolumn=
  autocmd BufLeave * if empty(expand('%')) 
	\ && empty(&buftype) && line('$') == 1 && getline(1) == '' 
        \ | execute 'bdelete!' | endif
augroup END
" }}}1

" packadd! FastFold
packadd! targets.vim 
packadd! vim-conjoin

" ignored files and directories {{{2
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
" }}}2

" These are evil: “ ” 
highlight Evil guifg=red guibg=orange 
match Evil /“\|”/

" vim: ft=vim fdm=marker sw=2 sts=2
