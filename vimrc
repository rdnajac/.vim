" rdnajac's vimrc "{{{1
if &compatible			  " technically, vim is always incompatible when a
  set nocompatible		  " vimrc is present, but let's handle the edge case
endif			          " when vim is run with the -u flag
set matchtime=1
filetype plugin indent on	  " enable filetype detection, plugins, and indenting
let $v = $HOME.'/.vim'

" If sourcing this file from Neovim, skip setting these defaults:
if !has('nvim')
  syntax enable                   " prefer over `syntax on`
  set encoding=utf-8              " http://rbtnn.hateblo.jp/entry/2014/12/28/010913
  scriptencoding utf-8            " see :h :scriptencoding
  set mouse=a                     " wait, that's illegal
  set hidden                      " enable background buffers
  set autoindent smarttab         " enable auto-indent and smart tabbing
  set autoread autowrite          " automatically read/write files when changed
  set backspace=indent,eol,start  " configure backspace behavior to be more intuitive
  set formatoptions+=j            " delete comment character when joining lines
  " set formatoptions-=o           " don't continue comments when pressing 'o'
  set hlsearch incsearch          " highlighted, incremental search
  runtime ftplugin/man.vim        " read the manual!
  " under the hood {{{2
  set swapfile backup undofile
  function s:MkdirIfNotExists(dir)
    if !isdirectory(a:dir)
      call mkdir(a:dir, 'p', 0700)
    endif
  endfunction
  let &directory = $v.'/.swap'
  let &backupdir = $v.'/.backup'
  let undodir = $v.'/.undo'
  call s:MkdirIfNotExists(&directory)
  call s:MkdirIfNotExists(&backupdir)
  call s:MkdirIfNotExists(&undodir)
  "set undolevels=1000    " default is 1000 on Unix, ubsted on macos
  "set undoreload=10000   " default is 10000
  set spellfile=~/.vim/.spell/en.utf-8.add
  set viminfo='10000,n$HOME/.vim/.viminfo
  set clipboard=unnamed
else
  set clipboard=unnamedplus
  "set noshowmode      " disable showmode
  "set noshowcmd       " disable showcmd
  "set noruler         " disable ruler
endif
" }}}2
" }}}1

" configure colorscheme
set termguicolors
try
  silent! colorscheme tokyomidnight
catch
  colorscheme retrobox
endtry

set cursorline
set foldcolumn=0
set number numberwidth=3 relativenumber
set pumheight=10
set signcolumn=yes
set splitbelow splitright

" text appearance
set nowrap                          " don't wrap lines by default
set linebreak                       " if we have to, don't split words
set scrolloff=4 sidescrolloff=0     " scroll settings

set softtabstop=2 shiftwidth=2
set shiftround

" performance
set timeoutlen=300
set updatetime=100
set lazyredraw
set whichwrap+=<,>,[,],h,l
set foldopen+=insert,jump

set completeopt=menuone,noselect    " show menu even if there's only one match
set numberwidth=3
set report=0                        " display how many replacements were made
set shortmess+=A                    " avoid 'hit-enter' prompts
set signcolumn=no

set conceallevel=0
" fillchars control the appearance of folds
set fillchars=fold:\ ,foldopen:▾,foldclose:▸,foldsep:│
set fillchars+=eob:\                " don't show end of buffer as a column of ~
set fillchars+=stl:\                " display spaces properly in statusline

" listchars control the appearance of whitespace
set listchars=trail:¿,tab:→\   " show trailing whitspace and tabs

augroup vimrc_quit
  autocmd!
  autocmd FileType help,man,qf,ale-info silent! nnoremap <silent> <buffer> q :close<CR> | set nobuflisted
  autocmd CmdwinEnter * quit
augroup END

augroup vimrc
  autocmd!
  " restore cursor position
  autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
  " Change the current directory to the directory of the file in the current
  autocmd BufEnter * if expand('%:p') != '' && filereadable(expand('%:p')) | lcd %:p:h | endif
augroup END

" search config files with ease
set path+=~/.vim/**
set path+=~/cbmf/**

" keep keymaps in a separate file
source $v/keymaps.vim

" searching {{{1
set showmatch     " highlight matching brackets
set ignorecase smartcase
set iskeyword+=-  " treat hyphens as part of a word
set iskeyword+=_  " treat underscores as part of a word
" wild {{{2
set wildmenu
" set wildmode=longest,list
set wildmode=longest:full,full
" set wildignorecase

" ignore these files and directories {{{3
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
" }}}3
" }}}2
" }}}1

" Modelines have historically been a source of security vulnerabilities. {{{
" TODO disable modelines and use the securemodelines script instead:
" http://www.vim.org/scripts/script.php?script_id=1876
" set nomodeline
" nevertheless...
" }}}
" vim:fdm=marker fdl=2
