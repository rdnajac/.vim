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
  
  if &ttimeoutlen == -1 | set ttimeout ttimeoutlen=100 | endif

  " set up vim home directory {{{2
  let s:vim_home = expand('$HOME/.vim/')
  " configure options for viminfo 
  " set viminfo=
  
  set undofile swapfile backup
  let &undodir     = s:vim_home . '.undo//'
  let &directory   = s:vim_home . '.swap//'
  let &backupdir   = s:vim_home . '.backup//'
  let &viminfofile = s:vim_home . '.viminfo'
  let &spellfile   = s:vim_home . '.spell/en.utf-8.add'
  " let &verbosefile = s:vim_home . '.vimlog.txt'

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
set foldopen+=insert,jump         " open folds when jumping to them or entering insert mode
"set foldopen=all
" set nofoldenable                  " don't fold by default; press 'zi' to toggle

" other settings {{{1
set autochdir                     " change directory to the file being edited
set ignorecase smartcase          " ignore case when searching, unless there's a capital letter
set softtabstop=4 shiftwidth=4    " don't change tabstop!
set whichwrap+=<,>,[,],h,l        " wrap around newlines with these keys 

set completeopt=menuone,noselect  " show menu even if there's only one match
set completeopt+=preview
set report=0                      " display how many replacements were made
set shortmess+=A                  " avoid 'hit-enter' prompts
set shortmess-=S                  " don't show search count
set wildmenu                      " just use the default wildmode with this setting

" set iskeyword+=-                  " treat hyphens as part of a word
" set isks per ft; in vim, this interferes with option-= 
" set shiftround
" set isfname+={,},\",\<,\>,(,),[,],\:
"
" from tpope/apathy
setglobal path=.,,
setglobal include=
setglobal includeexpr=
setglobal define=
setglobal isfname+=@-@

" add paths to path
set path +=$VIMRUNTIME/**
set path +=$HOME/.vim/**
set path +=$HOME/cbmf/**

" global variables
let g:is_bash        = 1
let g:tex_flavor     = "latex"
let g:mapleader      = ' '
let g:maplocalleader = ','

" keymaps {{{1
nnoremap <C-q> :call utils#smartQuit()<CR>
vnoremap <C-s> :sort<CR>
"nnoremap <C-m> :silent! make%<CR>redraw!

" double space over word to find and replace
nnoremap <Space><Space> :%s/\<<C-r>=expand("<cword>")<CR>\>/

nnoremap <leader>b :b <C-d>
" TODO fix this:
" nnoremap <leader>c :call info#HighlightGroup()<CR>
nnoremap <leader>c :call GetInfo()<CR>
nnoremap <leader>e :e!<CR>
" nnoremap <leader>f :find<space> **/
nnoremap <leader>f :find<space> 
nnoremap <leader>h :nohlsearch<CR>
nnoremap <leader>r :source $MYVIMRC<CR>
nnoremap <leader>t :TTags<space>*<space>*<space>.<CR>
nnoremap <leader>v :e $MYVIMRC<CR>
nnoremap <leader>w :w<CR>
nnoremap <leader>x :!./%<CR>
vnoremap <leader>r :<C-u>call utils#replaceSelection()<CR>
nnoremap <leader>i :execute 'verbose set '.expand("<cword>")<CR>
" swap lines in normal mode
" ft
" - interferes with vim-vinegar
" nnoremap - ddpkj
" nnoremap _ kddpk

" run current line
" nnoremap <leader>rl ^yg_:r!<C-r>"<CR>
" yank selection into command line
vnoremap <leader>c y:<C-r>"<C-b>

" buffer/window navigation {{{2
nnoremap <tab> :bnext<CR>
nnoremap <s-tab> :bprevious<CR>
nnoremap <leader><tab> :b#<CR>

" navigate splits with <C-hjkl>
packadd! vim-tmux-navigator

" better escape with jk/kj {{{2
inoremap jk <esc>
inoremap kj <esc>
vnoremap jk <esc>
vnoremap kj <esc>

" indent/dedent in normal mode with < and > {{{2
nnoremap > V`]>
nnoremap < V`]<

" move lines up and down {{{2
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

" toggle settings {{{2
nnoremap <leader>sl  :set list!<CR>:set list?<CR>
nnoremap <leader>sn  :set number!<CR>:set number?<CR>
nnoremap <leader>sr  :set relativenumber!<CR>:set relativenumber?<CR>
nnoremap <leader>sw  :set wrap!<CR>:set wrap?<CR>
nnoremap <leader>ss  :set spell!<CR>:set spell?<CR>
nnoremap <leader>sc  :set &colorcolumn = &colorcolumn == '' ? '81' : ''<CR>:set colorcolumn?<CR>
nnoremap <leader>sf  :set &foldcolumn  = &foldcolumn  == 0 ? 1 : 0<CR>:set foldcolumn?<CR>
nnoremap <leader>st  :set &showtabline = &showtabline == 2 ? 0 : 2<CR>:set showtabline?<CR>
nnoremap <leader>si  :set &showstatusline = &showstatusline == 2 ? 0 : 2<CR>:set showstatusline?<CR>
nnoremap <leader>ss  :set &showstatusline = &showstatusline == 2 ? 0 : 2<CR>:set showstatusline?<CR>

" better completion {{{2
inoremap <silent> <localleader>o <C-x><C-o>
inoremap <silent> <localleader>f <C-x><C-f>
inoremap <silent> <localleader>i <C-x><C-i>
inoremap <silent> <localleader>l <C-x><C-l>
inoremap <silent> <localleader>n <C-x><C-n>
inoremap <silent> <localleader>t <C-x><C-]>
inoremap <silent> <localleader>u <C-x><C-u>

" no more fat fingers! {{{2
cnoreabbrev <expr> X getcmdtype() == ':' && getcmdline() == 'X' ? 'xall' : 'X'
cnoreabbrev <expr> q getcmdtype() == ':' && getcmdline() == 'Q' ? 'xall' : 'X'

" center searches {{{2
nnoremap n nzzzv
nnoremap N Nzzzv
nnoremap * *zzzv
nnoremap # #zzzv
nnoremap g* g*zzzv
nnoremap g# g#zzzv

" abbreviations {{{2
iab <expr> lr: strftime('LAST REVISION: ' . '%Y-%m-%d')

" }}}1
" autocmds {{{1
augroup vimrc
  autocmd!
  " set (short) filetype-specific settings
  autocmd FileType c	    setlocal cindent noexpandtab
  autocmd FileType cpp	    setlocal cindent expandtab
  autocmd FileType python   setlocal cindent expandtab fdm=indent fdl=99
  autocmd FileType vim	    setlocal sw=2 sts=2        fdm=marker
  autocmd FileType tex      setlocal sw=2 sts=2 spell  fdm=syntax fdl=99
  " put a modline containing ft=vim at the end of vimrc to enable 

  " automatically quit cmd window
  autocmd CmdwinEnter * quit
augroup END

augroup jumpToLastPosition
  autocmd!
  autocmd BufReadPost *
	\ let line = line("'\"")
	\ | if line >= 1 && line <= line("$")
	\ |   execute "normal! g`\""
	\ |   execute "silent! normal! zozz"
	\ | endif
augroup END

augroup specialBuffers
  autocmd!
  " quit with 'q'
  autocmd FileType help,qf,netrw,man,ale-info
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

" add plugins {{{1


" save plugins in ~/.vim/pack/*/opt then packadd! 
" add plugin configurations to after/plugin/*.vim

" tpope plugins
" packadd! vim-scriptease
" packadd! vim-unimpaired
" packadd! vim-obsession
" packadd! vim-fugitive

" wellle plugins
" packadd! targets.vim 
" packadd! context.vim
" packadd! tmux-complete.vim

" TODO: quicklist manipulation https://github.com/romainl/vim-qlist


" https://gist.github.com/romainl {{{1
" Automatically set marks for certain filetypes {{{2
" Jump back to the mark with backtick followed by the mark letter
augroup AutomaticMarks 
  autocmd!
  autocmd BufLeave vimrc        normal! mV
  autocmd BufLeave *.vim        normal! mV
  autocmd BufLeave *.md         normal! mM
  autocmd BufLeave *.sh         normal! mS
augroup END

" Slightly more intuitive gt/gT {{{2
" https://gist.github.com/romainl/0f589e07a079ea4b7a77fd66ef16ebee
" nnoremap <expr> gt ":tabnext +" . v:count1 . '<CR>'
" nnoremap <expr> gT ":tabnext -" . v:count1 . '<CR>'

" gq wrapper {{{2
" - tries its best at keeping the cursor in place
" - tries to handle formatter errors
" function! Format(type, ...)
"     normal! '[v']gq
"     if v:shell_error > 0
"         silent undo
"         redraw
"         echomsg 'formatprg "' . &formatprg . '" exited with status ' . v:shell_error
"     endif
"     call winrestview(w:gqview)
"     unlet w:gqview
" endfunction
" nmap <silent> GQ :let w:gqview = winsaveview()<CR>:set opfunc=Format<CR>g@"

" quick and dirty whitespace-based alignment {{{2
" function! Align()
"	'<,'>!column -t|sed 's/  \(\S\)/ \1/g'
"	normal gv=
" endfunction
" xnoremap <silent> <key> :<C-u>silent call Align()<CR>

" opposite of J {{{2
" function! BreakHere()
"	s/^\(\s*\)\(.\{-}\)\(\s*\)\(\%#\)\(\s*\)\(.*\)/\1\2\r\1\4\6
"	call histdel("/", -1)
" endfunction
" nnoremap <key> :<C-u>call BreakHere()<CR>

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
" set nomodeline {{{1
" Modelines have historically been a source of security vulnerabilities. 
" TODO: disable modelines and use securemodelines
" http://www.vim.org/scripts/script.php?script_id=1876
" vim: ft=vim
