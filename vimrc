" vim:fdm=marker fdl=2
" rdnajac's vimrc "{{{1
if &compatible			  " technically, vim is always incompatible when a
  set nocompatible		  " vimrc is present, but let's handle the edge case
endif			          " when vim is run with the -u flag

filetype plugin indent on	  " enable filetype detection, plugins, and indenting

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
    set noerrorbells novisualbell   " disable error bells and visual bells
    runtime ftplugin/man.vim        " read the manual!

    " under the hood {{{2
    set swapfile backup undofile
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

" interface settings {{{1
set termguicolors

" configure colorscheme
try
	silent! colorscheme tokyomidnight
catch
	colorscheme retrobox
endtry

set cursorline
set foldcolumn=0
set number numberwidth=3 relativenumber
set pumheight=10
set showmatch
set signcolumn=yes
set splitbelow splitright

" text appearance
set nowrap                          " don't wrap lines by default
set linebreak                       " if we have to, don't split words
set scrolloff=4 sidescrolloff=0     " scroll settings

" vimscript, lua, and ocaml want 2 spaces, no tabs; and I don't want 3 extra
" ftplugin files, so here are the "defaults"
set softtabstop=2 shiftwidth=2
set shiftround

" performance
set timeoutlen=300
set updatetime=100
set lazyredraw
set whichwrap+=<,>,[,],h,l
set foldopen+=insert,jump

set completeopt=menuone,noselect    " show menu even if there's only one match
set conceallevel=0
set numberwidth=3
set report=0                        " display how many replacements were made
set shortmess+=A                    " avoid 'hit-enter' prompts
set signcolumn=no
set wildmenu
set wildmode=longest,list

set ignorecase smartcase
set iskeyword+=-  " treat hyphens as part of a word
set iskeyword+=_  " treat underscores as part of a word


" fillchars control the appearance of folds
set fillchars=fold:\ ,foldopen:▾,foldclose:▸,foldsep:│
set fillchars+=eob:\                " don't show end of buffer as a column of ~
set fillchars+=stl:\                " display spaces properly in statusline

" listchars control the appearance of whitespace
set listchars=trail:¿,tab:→\   " show trailing whitspace and tabs

augroup vimrc
  autocmd!
augroup END

augroup vimrc
    " close certain windows with `q`
    autocmd FileType help,man,quickfix,ale-info silent! nnoremap <silent> <buffer> q :close<CR> | set nobuflisted

    " quit the command line window immediately upon entering it
    autocmd CmdwinEnter * quit
augroup END

augroup RestoreCursorPosition
    autocmd!
    autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
    autocmd BufReadPost *   exe "normal! g'\""
    autocmd BufReadPost *   if winline() >= winheight(0) - 3 | exe "normal! zb" | endif
    autocmd BufReadPost *   exe "silent! normal! zo"
    autocmd BufReadPost *   exe "normal! zz"
augroup END

let g:mapleader = ' '
let g:maplocalleader = '\'

nnoremap ?         :call GetInfo()<cr>
nnoremap <leader>r :source $MYVIMRC<cr>
nnoremap <leader>w :w<cr>
nnoremap <leader>ev :vsplit $MYVIMRC<cr>
nnoremap <leader>eft <esc>:vsplit ~/.vim/after/ftplugin/
nnoremap <leader>eap <esc>:vsplit ~/.vim/after/plugin/
nnoremap <leader>eau <esc>:vsplit ~/.vim/autoload/
nnoremap <leader>Q :qa!<cr>
nnoremap <C-q>     :wqall<CR>


" toggle settings
nnoremap <leader>sl :set list!<CR>
nnoremap <leader>sn :set number!<CR>
nnoremap <leader>sr :set relativenumber!<CR>
nnoremap <leader>sw :set wrap!<CR>
nnoremap <leader>ss :set spell!<CR>
nnoremap <leader>scl :set cursorline!<CR>
" nnoremap <leader>scc :set cursorcolumn!<CR>
nnoremap <leader>sh :set hlsearch!<CR>

" indent/dedent visual block
nnoremap > V`]>
nnoremap < V`]<

" quick escape
inoremap jk <esc>
vnoremap jk <esc>
inoremap kj <esc>
vnoremap jk <esc>

" Move the current line up/down
nnoremap <silent> <C-k> :move .-2<CR>=
nnoremap <silent> <C-j> :move .+1<CR>==
xnoremap <silent> <C-k> :move '<-2<CR>gv=gv
xnoremap <silent> <C-j> :move '>+1<CR>gv=gv

" buffers and windows
nnoremap L :bnext<CR>
nnoremap <S-Tab> :bprevious<CR>

" force `:X` to behave like `:x`
cnoreabbrev <expr> X getcmdtype() == ':' && getcmdline() == 'X' ? 'x' : 'X'

command! -bang -nargs=* RG call fzf#vim#grep("rg --column --line-number --no-    heading --color=always --smart-case ".shellescape(<q-args>), 1, {'options': '--delimiter : --nth 4..'}, <bang>0)
nnoremap <C-f> :RG<cr>
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"

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
"}}}

" Modelines have historically been a source of security vulnerabilities.
" TODO disable modelines and use the securemodelines script instead:
" http://www.vim.org/scripts/script.php?script_id=1876
" set nomodeline
" nevertheless...
" vim:fdm=marker
