" vim: ft=vim foldmethod=marker sw=2 sts=2
" CAPS LOCK MAPS TO CTRL -- WHEN IN DOUBT, PINKY OUT
" rdnajac's vimrc {{{1
if !has('nvim')
  set encoding=utf-8              " http://rbtnn.hateblo.jp/entry/2014/12/28/010913
  scriptencoding utf-8
  
  " vim with a vimrc is always incompatible, but let's handle edge cases
  if &compatible | set nocompatible | endif                           

  " the following "sensible.vim" options have had their include guards removed
  set nolangremap		  " disable a legacy behavior that can break plugin maps
  filetype plugin indent on       " enable filetype detection, plugins, and indentation
  syntax enable                   " source $VIMRUNTIME/syntax/syntax.vim
  runtime! macros/matchit.vim     " enable % to match more than just parens
  runtime ftplugin/man.vim        " enable the :Man command shipped inside Vim
  
  set mouse=a                     " wait, that's illegal
  set hidden                      " enable background buffers
  set autoindent smarttab         " enable auto-indent and smart tabbing
  set autoread autowrite          " automatically read/write files when changed
  set backspace=indent,eol,start  " configure backspace behavior to be more intuitive
  set formatoptions+=j            " delete comment character when joining lines
  " set formatoptions-=o          " don't continue comments when pressing 'o'
  set hlsearch incsearch          " highlighted, incremental search
  set timeoutlen=420		  " ms for a mapped sequence to complete
  set updatetime=100              " used for CursorHold autocommands
  set nomodeline                  " modelines are a security risk
  
  if &ttimeoutlen == -1 | set ttimeout ttimeoutlen=100 | endif

  " set up vim home directory {{{2
  let s:VIMHOME = expand('$HOME/.vim/')
  " configure options for viminfo 
  " set viminfo=
  
  set undofile swapfile backup
  let &undodir     = s:VIMHOME . '.undo//'
  let &directory   = s:VIMHOME . '.swap//'
  let &backupdir   = s:VIMHOME . '.backup//'
  let &viminfofile = s:VIMHOME . '.viminfo'
  let &spellfile   = s:VIMHOME . '.spell/en.utf-8.add'
  " let &verbosefile = s:VIMHOME . '.vimlog.txt'

  if !isdirectory(&undodir)   | call mkdir(&undodir,   'p', 0700) | endif
  if !isdirectory(&directory) | call mkdir(&directory, 'p', 0700) | endif
  if !isdirectory(&backupdir) | call mkdir(&backupdir, 'p', 0700) | endif
  " }}}2
  " clipboard settings {{{2
  set clipboard=unnamed
else
  set clipboard=unnamedplus     
endif


" display settings {{{1
set termguicolors
silent! color scheme

set cursorline                    " highlight the current line
set lazyredraw                    " don't redraw the screen while executing macros, etc.
set nowrap                        " don't wrap lines by default
set linebreak                     " if we have to wrap lines, don't split words
set number relativenumber         " show (relative) line numbers
set numberwidth=3                 " line number column padding
set showmatch                     " highlight matching brackets
set pumheight=10                  " limit the number of items in a popup menu
set splitbelow splitright         " where to open new splits by default
set scrolloff=4 sidescrolloff=0   " scroll settings
set showcmd                       " show the command being typed
" set showcmdloc=statusline       " show command in statusline 
" set cmdheight=1                 " height of the command line
set listchars=trail:¿,tab:→\      " show trailing whitespace and tabs
set fillchars=                    " reset fillchars
set fillchars+=eob:\ ,		  " don't show end of buffer as a column of ~
set fillchars+=stl:\ ,            " display spaces properly in statusline

" signcolumn is default is auto
" set signcolumn=yes
" set signcolumn=no

" fold settings {{{2
set fillchars+=fold:\ ,foldopen:▾,foldclose:▸,foldsep:│
set foldmethod=marker		  " fold based on markers (default: {{{,}}})
set foldopen+=insert
set foldopen+=jump
"set foldopen=all
" set nofoldenable                  " don't fold by default; press 'zi' to toggle

" other settings {{{1
set autochdir                     " change directory to the file being edited
set completeopt=menuone,noselect  " show menu even if there's only one match
set completeopt+=preview
set ignorecase smartcase          " ignore case when searching, unless there's a capital letter
set report=0                      " display how many replacements were made
set softtabstop=4 shiftwidth=4    " don't change tabstop!
set shortmess+=A                  " avoid 'hit-enter' prompts
set shortmess-=S                  " don't show search count
" set shiftround
set whichwrap+=<,>,[,],h,l        " wrap around newlines with these keys 
set wildmenu                      " just use the default wildmode with this setting

" set iskeyword+=-                  " treat hyphens as part of a word
set iskeyword+=_
"
" tpope/apathy {{{1
setglobal path=.,,
setglobal include=
setglobal includeexpr=
setglobal define=
setglobal isfname+=@-@
" set isfname+={,},\",\<,\>,(,),[,],\:

" add paths to path
" set path +=$VIMRUNTIME/**
set path +=$HOME/.vim/**
set path +=$HOME/cbmf/**
set path +=$HOME/.files/**


" global variables {{{1
let g:is_bash                   = 1
let g:tex_flavor                = 'latex'
let g:vimtex_view_method        = 'skim'
let g:mapleader                 = ' '
let g:maplocalleader            = ','
let g:markdown_fenced_languages =
      \ ['bash=sh', 'c', 'python', 'vim']

" keymaps {{{1
nnoremap <C-x> V:Twrite1<CR>
nnoremap <C-q> :call utils#smartQuit()<CR>
vnoremap <C-s> :sort<CR>
"nnoremap <C-m> :silent! make%<CR>redraw!
nnoremap <silent> <leader>` :Lexplore<CR>

" double space over word to find and replace
nnoremap <Space><Space> :%s/\<<C-r>=expand("<cword>")<CR>\>/

nnoremap <leader>b :b <C-d>
nnoremap <leader>c :call GetInfo()<CR>
nnoremap <leader>e :e!<CR>
nnoremap <leader>f :find<space>
nnoremap <leader>h :nohlsearch<CR>
nnoremap <leader>i :execute 'verbose set '.expand("<cword>")<CR>
nnoremap <leader>r :source $MYVIMRC<CR>
nnoremap <leader>t :TTags<space>*<space>*<space>.<CR>
nnoremap <leader>v :e $MYVIMRC<CR>
nnoremap <leader>w :w<CR>
nnoremap <leader>x :!./%<CR>
vnoremap <leader>r :<C-u>call utils#replaceSelection()<CR>

" run current line
" nnoremap <leader>rl ^yg_:r!<C-r>"<CR>
" yank selection into command line
" vnoremap <leader>c y:<C-r>"<C-b>

" buffer/window navigation {{{2
nnoremap <tab> :bnext<CR>
nnoremap <s-tab> :bprevious<CR>
nnoremap <leader><tab> :b#<CR>

" better escape with jk/kj {{{2
inoremap jk <esc>
inoremap kj <esc>
vnoremap jk <esc>
vnoremap kj <esc>

" indent/dedent in normal mode with < and > {{{2
nnoremap > V`]>
nnoremap < V`]<

" move lines up and down {{{2
nnoremap - ddpkj
nnoremap _ kddpk
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

" toggle settings {{{2
nnoremap <leader>sl :set list!<CR>:set list?<CR>
nnoremap <leader>sn :set number!<CR>:set number?<CR>
nnoremap <leader>sr :set relativenumber!<CR>:set relativenumber?<CR>
nnoremap <leader>sw :set wrap!<CR>:set wrap?<CR>
nnoremap <leader>ss :set spell!<CR>:set spell?<CR>
nnoremap <leader>st :call <SID>toggleTabline()<CR>
nnoremap <leader>ss :call <SID>toggleStatusline()<CR>

function! s:toggleTabline()
  if &showtabline == 2 | set showtabline=0 | else | set showtabline=2 | endif
endfunction
function! s:toggleStatusline()
    if &laststatus == 2 | set laststatus=0 | else | set laststatus=2 | endif
endfunction

function! s:toggle(opt, default)
  let option = a:opt
  let default_value = a:default
  let command = 'if &' . option . ' == ' . default_value . ' | ' . 'set ' . option . '=0 | ' . 'else | ' . 'set ' . option . '=' . default_value . ' | ' . 'endif '
  echo command
  execute command
endfunction
" nnoremap <leader>ss :call <SID>toggle('statusline', 2)<CR>

" better completion {{{2
inoremap <silent> <localleader>o <C-x><C-o>
inoremap <silent> <localleader>f <C-x><C-f>
inoremap <silent> <localleader>i <C-x><C-i>
inoremap <silent> <localleader>l <C-x><C-l>
inoremap <silent> <localleader>n <C-x><C-n>
inoremap <silent> <localleader>t <C-x><C-]>
inoremap <silent> <localleader>u <C-x><C-u>

" fat fingers! {{{2
cnoreabbrev <expr> X getcmdtype() == ':' && getcmdline() == 'X' ? 'x' : 'X'
cnoreabbrev <expr> Q getcmdtype() == ':' && getcmdline() == 'Q' ? 'q' : 'Q'

" easy command line! {{{2
cnoreabbrev ?? verbose set ?<Left>
 
" center searches {{{2
nnoremap n nzzzv
nnoremap N Nzzzv
nnoremap * *zzzv
nnoremap # #zzzv
nnoremap g* g*zzzv
nnoremap g# g#zzzv

" abbreviations {{{2
iab <expr> lr: strftime('LAST REVISION: ' . '%Y-%m-%d')

" autocmds {{{1
augroup vimrc
  autocmd!
  " set (short) filetype-specific settings
  autocmd FileType c	    setlocal cindent noexpandtab
  autocmd FileType cpp	    setlocal cindent expandtab
  autocmd FileType python   setlocal cindent expandtab fdm=indent fdl=9
  autocmd FileType vim	    setlocal sw=2 sts=2        fdm=marker 
  autocmd FileType tex      setlocal sw=2 sts=2 spell  fdm=syntax fdl=9
  autocmd FileType markdown setlocal            spell             fdl=2

  " automatically quit cmd window
  autocmd CmdwinEnter * quit
  
  " automatically open quickfix window after 
  " running a command (that doesn't begin with 'l')
  autocmd QuickFixCmdPost [^l]* cwindow

  " if .vim/.netrwhist exists, delete it on vim close
  autocmd VimLeave * 
	      \ | let netrwhist = s:VIMHOME . '.netrwhist'
	      \ | if filereadable(netrwhist) | call delete(netrwhist) | endif
augroup END

augroup RestoreCursor
    autocmd!
    autocmd BufReadPost *
		\ let line = line("'\"")
		\ | if line >= 1 && line <= line("$")
		\ |   execute "normal! g`\""
		\ |   execute "silent! normal! zo"
		\ | endif
augroup END

augroup specialBuffers
    autocmd!
    autocmd FileType help,qf,netrw,man
		\ silent! nnoremap <silent> <buffer> q :<C-U>close<CR> 
		\ | set nobuflisted
		\ | setlocal noruler
		\ | setlocal laststatus=0 
		\ | setlocal colorcolumn=
augroup END

augroup shebangs
    autocmd!
    " TODO put these in ftplugins
    " autocmd BufNewFile *.sh call utils#SheBangs('')
    " autocmd BufNewFile *.py call utils#SheBangs('#!/usr/bin/env python3')
    " autocmd BufNewFile *.pl call utils#SheBangs('#!/usr/bin/env perl')
    " autocmd BufNewFile *.R  call utils#SheBangs('#!/usr/bin/env Rscript')
augroup END

" plugins {{{1
" save plugins in ~/.vim/pack/*/opt then packadd! 
" add plugin configurations to after/plugin/*.vim

" packadd! vim-qlist
packadd! vim-conjoin

" tpope plugins
packadd! vim-fugitive
" packadd! vim-scriptease
" packadd! vim-unimpaired

" wellle plugins
" packadd! targets.vim 
" }}}

function! Fmt()
    let winview = winsaveview()
    " now gq the whole thing
    normal! gggqG
    if v:shell_error > 0
	silent undo
	redraw
	echomsg 'formatprg "' . &formatprg . '" exited with status ' . v:shell_error
    endif
    call winrestview(winview)
endfunction
" nmap <silent> Q :let w:gqview = winsaveview()<CR>:set opfunc=Format<CR>g@"

" defaults.vim {{{1
" defaults.vim is not loaded when using a vimrc file,
" so let's copy the ones we want to use
set nrformats-=octal		  " Ignore octal numbers for Ctrl-A and Ctrl-X
let c_comment_strings=1	          " I like highlighting strings inside C comments.

" CTRL-U in insert mode deletes a lot. Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" see the difference between current buffer and the file it was loaded from.
if !exists(":DiffOrig")
    command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis | wincmd p | diffthis
endif

" https://gist.github.com/romainl {{{1
augroup AutomaticMarks 
    autocmd!
    autocmd BufLeave vimrc        normal! mV
    autocmd BufLeave *.vim        normal! mV
    autocmd BufLeave *.md         normal! mM
    autocmd BufLeave *.sh         normal! mS
augroup END

" Slightly more intuitive gt/gT
" nnoremap <expr> gt ":tabnext +" . v:count1 . '<CR>'
" nnoremap <expr> gT ":tabnext -" . v:count1 . '<CR>'

" opposite of J
function! BreakHere()
    s/^\(\s*\)\(.\{-}\)\(\s*\)\(\%#\)\(\s*\)\(.*\)/\1\2\r\1\4\6
    call histdel("/", -1)
endfunction
nnoremap <C-j>  :<C-u>call BreakHere()<CR>

" ignore these files and directories {{{1
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
