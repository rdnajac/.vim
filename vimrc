" vim: fdm=marker fdl=2:

" settings {{{1
filetype plugin indent on
set showcmd cmdheight=1
set timeoutlen=300
set updatetime=100
set lazyredraw
set scrolloff=4 sidescrolloff=0
set whichwrap+=<,>,[,],h,l
set foldopen+=insert,jump
set shiftwidth=2 tabstop=4 expandtab
set nowrap linebreak

if !has('nvim') " {{{2
  syntax enable                   " prefer `:syntax enable` over `:syntax on
  set autoindent smarttab         " enable auto-indent and smart tabbing
  set autoread autowrite          " auto read and write files when changed
  set backspace=indent,eol,start  " backspace behavior
  set encoding=utf-8              " nvim default is utf-8
  set formatoptions+=j            " delete comment character when joining lines
  set hidden                      " enable background buffers
  set hlsearch incsearch          " highlighted, incremental search
  set mouse=a                     " enable mouse in all modes
  set nocompatible                " vim behaves like vim, not like vi
  set noerrorbells novisualbell   " disable error bells and visual bells
  " access man pages in vim {{{3
  if exists(':Man') != 2 && !exists('g:loaded_man') && &filetype !=? 'man'
    runtime ftplugin/man.vim
  endif
  " }}}3
  " under the hood {{{3
  set swapfile
  if !isdirectory(expand("~/.vim/.swap"))
    call mkdir(expand("~/.vim/.swap"), "p", 0700)
  endif
  let &directory = expand("~/.vim/.swap")

  set undofile
  set undolevels=1000
  set undoreload=10000
  if !isdirectory(expand("~/.vim/.undo"))
    call mkdir(expand("~/.vim/.undo"), "p", 0700)
  endif
  let &undodir = expand("~/.vim/.undo")

  set backup
  if !isdirectory(expand("~/.vim/.backup"))
    call mkdir(expand("~/.vim/.backup"), "p", 0700)
  endif
  let &backupdir = expand("~/.vim/.backup")

  set spell
  if !isdirectory(expand("~/.vim/.spell"))
    call mkdir(expand("~/.vim/.spell"), "p", 0700)
  endif
  set spellfile=~/.vim/.spell/en.utf-8.add
  " }}}3
  set clipboard=unnamed
else
  set clipboard=unnamedplus
  "set noshowmode      " disable showmode
  "set noshowcmd       " disable showcmd
  "set noruler         " disable ruler
endif

" searh and matching {{{2
set ignorecase smartcase
"set matchtime=2  " default is 5
set iskeyword+=-  " treat hyphens as part of a word
"set iskeyword+=_  " treat underscores as part of a word

" display settings {{{2
set background=dark termguicolors
set cursorline
set number numberwidth=3 relativenumber
set pumheight=10
set showmatch
set signcolumn=yes
set splitbelow splitright

" ignore these files and directories {{{2
set wildignore+=
      \*.exe,*.out,*.cm*,*.o,*.a,*.so,*.dll,*.dylib,*.lib,*.bin,*.app,*.apk,*.dmg,*.iso,*.msi,*.deb,*.rpm,*.pkg,
      \*.class,*.jar,*.pyo,*.pyd,*.node,*.swp,*.swo,*.tmp,*.temp,*.DS_Store,Thumbs.db,
      \*/.git/*,*/.hg/*,*/.svn/*,
      \*.pdf,*.aux,*.fdb_latexmk,*.fls,
      \*.jpg,*.png,*.gif,*.bmp,*.tiff,*.ico,*.svg,*.webp,*.img,
      \*.mp3,*.mp4,*.avi,*.mkv,*.mov,*.flv,*.wmv,*.webm,*.m4v,*.flac,*.wav,
      \*.zip,*.tar.gz,*.rar,*.7z,*.tar.xz,*.tgz,
      \*/node_modules/*,*/vendor/*,*/build/*,*/dist/*,*/out/*,*/bin/*,*/.vscode/*,*/__pycache__/*,*/.cache/*
" }}}2

" autocmds {{{2
augroup myautocommands
  autocmd!

  " Source .vimrc after saving
  autocmd BufWritePost $MYVIMRC source $MYVIMRC

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

" which-key {{{2
let g:which_key_map =  {}
nnoremap <silent> <leader> :<c-u>WhichKey '<Space>'<CR>
vnoremap <silent> <leader> :<c-u>WhichKeyVisual '<Space>'<CR>
"call which_key#register('<Space>', "g:which_key_map")

" }}}2

" additional settings {{{1
"set wildmode=longest:list,full
set completeopt=menuone,noselect    " show menu even if there's only one match
set conceallevel=0
set fillchars=fold:\ ,foldopen:▾,foldclose:▸,foldsep:│
set fillchars+=eob:\                " don't show end of buffer as a column of ~
set fillchars+=stl:\                " display spaces properly in statusline
set fo-=o
set foldcolumn=0
set list listchars=trail:¿,tab:→\   " show trailing whitspace and tabs
set numberwidth=3
set report=0                        " display how many replacements were made
set shortmess+=A                    " avoid "hit-enter" prompts
set signcolumn=no
set wildmenu
set wildmode=longest,list

color yowish
hi Normal guibg=#000000
hi String guifg=#39FF14
hi Folded guifg=#14AFFF guibg=#000000
hi FoldColumn guibg='#000000' guifg='#000000'
hi clear SpellBad
hi clear SpellRare
hi SpellBad cterm=italic ctermfg=red guifg=red
hi SpellRare cterm=italic ctermfg=blue guifg=blue

