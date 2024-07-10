" rdnajac's vimrc {{{
if !has('nvim')
    " sensible.vim {{{
    if &compatible                  " technically, vim is always incompatible when a
	set nocompatible              " vimrc is present, but let's handle the edge case
    endif                           " when vim is run with the -u flag

    if has('langmap') && exists('+langremap') && &langremap
	set nolangremap  " Disable a legacy behavior that can break plugin maps.
    endif

    if !(exists('g:did_load_filetypes') && exists('g:did_load_ftplugin') && exists('g:did_indent_on'))
	filetype plugin indent on
    endif

    if has('syntax') && !exists('g:syntax_on')
	syntax enable
    endif

    " Correctly highlight $() and other modern affordances in filetype=sh.
    " if !exists('g:is_posix') && !exists('g:is_bash') && !exists('g:is_kornshell') && !exists('g:is_dash')
    "   let g:is_posix = 1
    " endif
    " Load matchit.vim, but only if the user hasn't installed a newer version.
    if !exists('g:loaded_matchit') && findfile('plugin/matchit.vim', &rtp) ==# ''
	runtime! macros/matchit.vim
    endif
    " Enable the :Man command shipped inside Vim's man filetype plugin.
    if exists(':Man') != 2 && !exists('g:loaded_man') && &filetype !=? 'man' && !has('nvim')
	runtime ftplugin/man.vim
    endif
    " }}}
    set encoding=utf-8              " http://rbtnn.hateblo.jp/entry/2014/12/28/010913
    scriptencoding utf-8            " see `:h :scriptencoding`
    set mouse=a                     " wait, that's illegal
    set hidden                      " enable background buffers
    set autoindent smarttab         " enable auto-indent and smart tabbing
    set autoread autowrite          " automatically read/write files when changed
    set backspace=indent,eol,start  " configure backspace behavior to be more intuitive
    set formatoptions+=j            " delete comment character when joining lines
    " set formatoptions-=o          " don't continue comments when pressing 'o'
    set hlsearch incsearch          " highlighted, incremental search
    set swapfile backup undofile    " {{{
    function! s:MkdirIfNotExists(dir) abort " {{{
	if !isdirectory(a:dir)
	    call mkdir(a:dir, 'p', 0700)
	endif
    endfunction " }}}
    let &backupdir = expand('~/.vim/.backup')
    let &directory = expand('~/.vim/.swap')
    set undodir=~/.vim/.undo

    call s:MkdirIfNotExists(&backupdir)
    call s:MkdirIfNotExists(&directory)
    call s:MkdirIfNotExists(&undodir)
    set spellfile=~/.vim/.spell/en.utf-8.add
    set viminfo='10000,n~/.vim/.viminfo
    set verbosefile=~/.vim/.vimlog.txt
    set clipboard=unnamed
    " }}}
    " performance {{{
    set updatetime=100              " used for CursorHold autocommands
    if &ttimeoutlen == -1
	set ttimeout
	set ttimeoutlen=100
    endif
    set timeoutlen=300		  " time for a mapped sequence to complete
" }}}
else
    " neovim-specific settings {{{
    set clipboard=unnamedplus     
    " }}}
endif
" }}}
" display settings {{{
set termguicolors
silent! color scheme

set lazyredraw                    " don't redraw the screen while executing macros, etc.
set nowrap                        " don't wrap lines by default
set linebreak                     " if we have to wrap lines, don't split words
set number relativenumber         " show (relative) line numbers
set numberwidth=3                 " line number column padding
set showmatch                     " highlight matching brackets
set cursorline                    " highlight the current line
set splitbelow splitright         " where to open new splits by default
set scrolloff=4 sidescrolloff=0   " scroll settings
set showcmd
" set showcmdloc=statusline       " show command in statusline 
" set cmdheight=1                 " height of the command line
" set pumheight=10
set listchars=trail:¿,tab:→\
set fillchars=
set fillchars+=fold:\ ,foldopen:▾,foldclose:▸,foldsep:│
set fillchars+=eob:\ ,		  " don't show end of buffer as a column of ~
set fillchars+=stl:\ ,            " display spaces properly in statusline
" signcolumn is default is auto
" set signcolumn=yes
" set signcolumn=no
" }}}

set autochdir                     " change directory to the file being edited
set completeopt=menuone,noselect  " show menu even if there's only one match
set ignorecase smartcase          " ignore case when searching, unless there's a capital letter
set iskeyword+=-                  " treat hyphens as part of a word
set report=0                      " display how many replacements were made
set shortmess+=A                  " avoid 'hit-enter' prompts
set softtabstop=4 shiftwidth=4    " don't change tabstop!
set whichwrap+=<,>,[,],h,l        " wrap around newlines with these keys 
set wildmenu                      " just use the default wildmode with this setting

" set foldopen+=insert,jump        " open folds when jumping to them or entering insert mode
" set shiftround
" set isfname+={,},\",\<,\>,(,),[,],\:

let g:mapleader      = ' '
let g:maplocalleader = ','

nnoremap <tab> :bnext<CR>
nnoremap <s-tab> :bprevious<CR>
nnoremap <leader><tab> :b#<CR>
nnoremap <C-q> :wqall<CR>
nnoremap <leader>b :b <C-d>
nnoremap <leader>c :call info#HighlightGroup()<CR>
nnoremap <leader>e :e!<CR>
nnoremap <leader>f :find<space>
nnoremap <leader>h :set hlsearch!<CR>
nnoremap <leader>m :make<CR>
nnoremap <leader>q :call utils#smartQuit()<CR>
nnoremap <leader>r :source $MYVIMRC<CR>
nnoremap <leader>t :TTags<space>*<space>*<space>.<CR>
nnoremap <leader>v :e $MYVIMRC<CR>
nnoremap <leader>w :w<CR>
nnoremap <leader>x :!./%<CR>
vnoremap <leader>r :<C-u>call utils#replaceSelection()<CR>

" run current line
" nnoremap <leader>rl ^yg_:r!<C-r>"<CR>
" yank selection into command line
vnoremap <leader>c y:<C-r>"<C-b>

" more keymaps {{{1
" better escape with jk/kj {{{2
noremap jk <esc>
noremap kj <esc>
" inoremap jk <esc>
" inoremap kj <esc>
" vnoremap jk <esc>
" vnoremap kj <esc>

" indent/dedent in normal mode with < and > {{{2
nnoremap > V`]>
nnoremap < V`]<

" toggle settings {{{2
nnoremap <leader>sh  :set hlsearch!<CR>
nnoremap <leader>sl  :set list!<CR>
nnoremap <leader>sn  :set number!<CR>
nnoremap <leader>sr  :set relativenumber!<CR>
nnoremap <leader>sw  :set wrap!<CR>
nnoremap <leader>ss  :set spell!<CR>
nnoremap <leader>scl :set cursorline!<CR>
nnoremap <leader>scc :set cursorcolumn!<CR>
nnoremap <leader>sfc :let &foldcolumn  = (&foldcolumn  == 0 ? 1 : 0)<CR>
nnoremap <leader>st  :let &showtabline = (&showtabline == 2 ? 0 : 2)<CR>
nnoremap <leader>ss  :let &laststatus  = (&laststatus  == 2 ? 0 : 2)<CR>

" better completion {{{2
inoremap <silent> <localleader>o <C-x><C-o>
inoremap <silent> <localleader>f <C-x><C-f>
inoremap <silent> <localleader>i <C-x><C-i>
inoremap <silent> <localleader>l <C-x><C-l>
inoremap <silent> <localleader>n <C-x><C-n>
inoremap <silent> <localleader>t <C-x><C-]>
inoremap <silent> <localleader>u <C-x><C-u>

" no more fat fingers! {{{2
cnoreabbrev <expr> X getcmdtype() == ':' && getcmdline() == 'X' ? 'x' : 'X'

" end keymaps }}}1

augroup vimrc " {{{1
    autocmd!
    autocmd FileType c          setlocal cindent noexpandtab
    autocmd FileType cpp,python setlocal cindent expandtab
    autocmd FileType vim        setlocal fdm=marker

    " automatically quit cmd window
    autocmd CmdwinEnter * quit
augroup END

augroup jumpToLastPosition " {{{1
    autocmd!
    autocmd BufReadPost *
		\ let line = line("'\"")
		\ | if line >= 1 && line <= line("$")
		\ |   execute "normal! g`\""
		\ | endif
augroup END

augroup specialBuffers " {{{1
    autocmd!
    " quit with 'q'
    autocmd FileType help,qf,netrw,man,ale-info
		\ silent! nnoremap <silent> <buffer> q :<C-U>close<CR> 
		\ | set nobuflisted
		\ | setlocal noruler
		\ | setlocal laststatus=0 
augroup END

augroup shebangs " {{{1
    autocmd!
    " autocmd BufNewFile *.sh call utils#SheBangs('')
    " autocmd BufNewFile *.py call utils#SheBangs('#!/usr/bin/env python3')
    " autocmd BufNewFile *.pl call utils#SheBangs('#!/usr/bin/env perl')
    " autocmd BufNewFile *.R  call utils#SheBangs('#!/usr/bin/env Rscript')
augroup END

" plugins {{{1
" save in ~/.vim/pack/*/opt then packadd! them
packadd! ale
packadd! copilot.vim

" tpope plugins
packadd! vim-commentary
packadd! vim-eunuch
packadd! vim-repeat 
packadd! vim-scriptease
packadd! vim-surround
packadd! vim-tbone
packadd! vim-vinegar
" packadd! vim-apathy
" TODO delete this and figure out apathy
set path+=~/.vim/**,~/cbmf/** 
" packadd! vim-unimpaired
" packadd! vim-obsession
" packadd! vim-fugitive

" wellle plugins
" packadd! targets.vim 
" packadd! context.vim
" packadd! tmux-complete.vim

packadd! vim-tmux-navigator

" romainl gists {{{1
" https://gist.github.com/romainl/3e0cb99343c72d04e9bc10f6d76ebbef
" return to the mark with ` plus letter
augroup AutomaticMarks 
    autocmd!
    autocmd BufLeave vimrc        normal! mV
    autocmd BufLeave *.vim        normal! mV
    autocmd BufLeave *.md         normal! mM
    autocmd BufLeave *.sh         normal! mS
augroup END

" Slightly more intuitive gt/gT (may need some unlearning to get used to)
" https://gist.github.com/romainl/0f589e07a079ea4b7a77fd66ef16ebee
" nnoremap <expr> gt ":tabnext +" . v:count1 . '<CR>'
" nnoremap <expr> gT ":tabnext -" . v:count1 . '<CR>'

" gq wrapper that:
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
"
" Use a bunch of standard UNIX commands for quick an dirty
" whitespace-ba sed alignment
" function! Align()
" 	'<,'>!column -t|sed 's/  \(\S\)/ \1/g'
" 	normal gv=
" endfunction
" xnoremap <silent> <key> :<C-u>silent call Align()<CR>

" function! BreakHere()
" 	s/^\(\s*\)\(.\{-}\)\(\s*\)\(\%#\)\(\s*\)\(.*\)/\1\2\r\1\4\6
" 	call histdel("/", -1)
" endfunction
" nnoremap <key> :<C-u>call BreakHere()<CR>

" TODO: redirect output
" https://gist.github.com/romainl/eae0a260ab9c135390c30cd370c20cd7
" TODO: quicklist manipulation
" https://github.com/romainl/vim-qlist

" defaults.vim {{{
" Do not recognize octal numbers for Ctrl-A and Ctrl-X
set nrformats-=octal

" CTRL-U in insert mode deletes a lot.
" Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" I like highlighting strings inside C comments.
let c_comment_strings=1

" Convenient command to see the difference between 
" the current buffer and the file it was loaded from.
if !exists(":DiffOrig")
    command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
		\ | wincmd p | diffthis
endif

" ignore these files and directories {{{
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

" set nomodeline {{{1
" Modelines have historically been a source of security vulnerabilities. 
" TODO: disable modelines and use securemodelines
" http://www.vim.org/scripts/script.php?script_id=1876
" }}}1
" vim: ft=vim: fdm=marker:
