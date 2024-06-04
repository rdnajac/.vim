" https://github.com/rdnajac/.vim/blob/main/vimrc
" https://vimdoc.sourceforge.net/htmldoc/options.html#:options
filetype plugin indent on  " enable filetype-specific settings

" set nocompatible         " don't set this; see :h 'nocompatible'

set showcmd cmdheight=1
set timeoutlen=300
set updatetime=100
set lazyredraw
set scrolloff=4 sidescrolloff=0
set whichwrap+=<,>,[,],h,l
set foldopen+=insert,jump
set shiftwidth=4 tabstop=4
set expandtab
set nowrap linebreak

" If sourcing this file from Neovim, skip setting these defaults:
if !has('nvim') " {{{1
    syntax enable                   " prefer over `syntax on`
    set mouse=a                     " wait, that's illegal
    set hidden                      " enable background buffers
    set autoindent smarttab         " enable auto-indent and smart tabbing
    set autoread autowrite          " automatically read/write files when changed
    set backspace=indent,eol,start  " configure backspace behavior to be more intuitive
    set formatoptions+=j            " delete comment character when joining lines
    set hlsearch incsearch          " highlighted, incremental search
    set noerrorbells novisualbell   " disable error bells and visual bells
    set encoding=utf-8
    scriptencoding utf-8            " see :h :scriptencoding
    runtime ftplugin/man.vim        " read the manual!
    set swapfile backup undofile " {{{2
    function s:MkdirIfNotExists(dir)
      if !isdirectory(a:dir)
        call mkdir(a:dir, 'p', 0700)
      endif
    endfunction

    let &directory = expand('~/.vim/.swap')
    call s:MkdirIfNotExists(&directory)

    let &backupdir = expand('~/.vim/.backup')
    call s:MkdirIfNotExists(&backupdir)

    let &undodir = expand('~/.vim/.undo')
    call s:MkdirIfNotExists(&undodir)
    "set undolevels=1000    " default is 1000 on Unix, ubsted on macos
    "set undoreload=10000   " default is 10000
    " }}}2
    set spellfile=~/.vim/.spell/en.utf-8.add
    set clipboard=unnamed
else
    set clipboard=unnamedplus
    "set noshowmode      " disable showmode
    "set noshowcmd       " disable showcmd
    "set noruler         " disable ruler
endif

set completeopt=menuone,noselect    " show menu even if there's only one match
set conceallevel=0
set numberwidth=3
set report=0                        " display how many replacements were made
set shortmess+=A                    " avoid "hit-enter" prompts
set signcolumn=no
set wildmenu
set wildmode=longest,list

" display settings {{{1
set background=dark termguicolors
set cursorline
set number numberwidth=3 relativenumber
set pumheight=10
set showmatch
set signcolumn=yes
set splitbelow splitright
" Folding {{{2

set foldcolumn=0

" Fillchars control the appearance of folds
set fillchars=fold:\ ,foldopen:▾,foldclose:▸,foldsep:│
set fillchars+=eob:\                " don't show end of buffer as a column of ~
set fillchars+=stl:\                " display spaces properly in statusline
" }}}2

" Listchars control the appearance of whitespace
set list listchars=trail:¿,tab:→\   " show trailing whitspace and tabs

" }}}1

" searh and matching {{{2
set ignorecase smartcase
set iskeyword+=-  " treat hyphens as part of a word
set iskeyword+=_  " treat underscores as part of a word


" autocmds {{{2
augroup myautocommands
    autocmd!

    " Change local directory to the file's directory on buffer enter
    autocmd BufEnter * :lchdir %:p:h

    " Map 'q' to close the buffer for certain file types
    autocmd FileType help,man,netrw,quickfix silent! nnoremap <silent> <buffer> q :close<CR> | set nobuflisted

    " Go to last cursor position when opening a file
    autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g'\"" | if winline() >= winheight(0) - 3 | exe "normal! zb" | endif | endif

    " Reload file if it has changed outside of Vim
    autocmd FocusGained * checktime
augroup END

" keymaps {{{1
let mapleader = "\<space>"

nnoremap ?         :call GetInfo()<cr>
nnoremap <leader>r :source $MYVIMRC<cr> : echo ">^.^<"<cr>
nnoremap <leader>w :w<cr>
nnoremap <leader>Q :qa!<cr>
nnoremap <leader>h :set hlsearch!<cr>
nnoremap <leader>t :set list!<cr>
nnoremap <leader>o i<cr><esc>
nnoremap <C-q>     :wqall<CR>
vnoremap <leader>f :<c-u>let @/ = '\V' . escape(@s, '\')<cr>

" indent/dedent visual block
nnoremap > V`]>
nnoremap < V`]<

" quick escape
inoremap jk <esc>
vnoremap jk <esc>
inoremap kj <esc>
vnoremap jk <esc>

" TODO test move text up and down
nnoremap <silent> <M-j> :m .+1<CR>==
nnoremap <silent> <M-k> :m .-2<CR>==

" buffers and windows
nnoremap L :bnext<CR>
nnoremap <S-Tab> :bprevious<CR>
nnoremap <leader>bl :ls<CR>

" force `:X` to behave like `:x`
cnoreabbrev <expr> X getcmdtype() == ':' && getcmdline() == 'X' ? 'x' : 'X'


" Set the default colorscheme with fallbacks
if filereadable(expand('~/.vim/colors/tokyomidnight.vim'))
    colorscheme tokyomidnight
else
    try
        colorscheme retrobox
    catch /^Vim\%((\a\+)\)\=:E185/
        colorscheme ron
    endtry
endif

" TODO make this ft-specific
set formatoptions-=o " don't continue comments when pressing 'o'

" Ignore these files and directories {{{
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
"}}}

" Modelines have historically been a source of security vulnerabilities.
" TODO disable modelines and use the securemodelines script instead:
" http://www.vim.org/scripts/script.php?script_id=1876
" set nomodeline
" nevertheless...
" vim:fdm=marker
