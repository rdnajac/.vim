" vimrc
scriptencoding utf-8

" let s:VIMHOME    = expand('$HOME/.vim/')
let s:VIMHOME    = expand('$XDG_CONFIG_HOME/vim/')
let g:plug_home  = s:VIMHOME . '/.plugged//'
let &backupdir   = s:VIMHOME . '.backup//'
let &directory   = s:VIMHOME . '.swap//'
let &undodir     = s:VIMHOME . '.undo//'
let &viminfofile = s:VIMHOME . '.viminfo'
let &spellfile   = s:VIMHOME . '.spell/en.utf-8.add'
" let &verbosefile = s:VIMHOME . '.vimlog.txt'
set undofile swapfile backup

let g:mapleader = ' '
let g:maplocalleader = '/'

call plug#begin()
" Plug 'rdnajac/after'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-apathy'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-scriptease'
Plug 'tpope/vim-speeddating'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-tbone'
Plug 'tpope/vim-vinegar'
" only load plugins on certain filetypes
Plug 'lervag/vimtex', { 'for': 'tex' }
call plug#end() " executes `filetype plugin indent on` and `syntax enable`

" better escape
noremap jk <esc>
noremap kj <esc>

nnoremap <leader>v :e $MYVIMRC<CR>
nnoremap <leader>r :source $MYVIMRC<CR>

" center searches
nnoremap n nzzzv
nnoremap N Nzzzv
nnoremap * *zzzv
nnoremap # #zzzv
nnoremap g* g*zzzv
nnoremap g# g#zzzv

" better completion
inoremap <silent> ,o <C-x><C-o>
inoremap <silent> ,f <C-x><C-f>
inoremap <silent> ,i <C-x><C-i>
inoremap <silent> ,l <C-x><C-l>
inoremap <silent> ,n <C-x><C-n>
inoremap <silent> ,t <C-x><C-]>
inoremap <silent> ,u <C-x><C-u>

set tabline=%!ui#tabline()
set statusline=%!ui#statusline()
set showtabline=2
set laststatus=2

augroup autoRestoreCursor
  autocmd!
  autocmd BufReadPost *
        \ let line = line("'\"")
        \ | if line >= 1 && line <= line("$")
        \ |   execute "normal! g`\""
        \ |   execute "silent! normal! zO"
        \ | endif
augroup END

augroup autoMkdir
  autocmd!
  autocmd BufWritePre * call file#automkdir(expand('<afile>'))
augroup END

augroup quickfix
  autocmd!
  autocmd QuickFixCmdPost [^l]* cwindow | silent! call ui#qf_signs()
  autocmd QuickFixCmdPost   l*  lwindow | silent! call ui#qf_signs()
augroup END

silent! colorscheme tokyonight-night

" syntax
" https://stackoverflow.com/a/28399202/26469286
" For files that don't have filetype-specific syntax rules
" autocmd BufNewFile,BufRead *syntax match NotPrintableAscii "[^\x20-\x7F]"
" For files that do have filetype-specific syntax rules
" autocmd Syntax * syntax match NotPrintableAscii "[^\x20-\x7F]" containedin=ALL
" hi NotPrintableAscii ctermbg=236

highlight Evil guifg=red guibg=orange

augroup mySyntax
  autocmd!
  autocmd BufNewFile,BufRead * syntax match Evil /“\|”/
  autocmd Syntax * syntax match Evil /“\|”/
  " highlight error for vim scripts
  autocmd BufReadPost,BufNewFile *.vim  if search('vim9script', 'nw') == 0 | syn match Error /^\s*#.*$/ | endif
augroup END

highlight CommentStringInBackticks guibg=NONE guifg=#39ff14
syntax region CommentStringInBackticks start=/`/ end=/`/ contained containedin=.*Comment

augroup quit_on_q
  autocmd!
  autocmd FileType help,qf,man silent! nnoremap <silent> <buffer> q :<C-U>close<CR>
augroup END

" vim: ft=vim fdm=marker sw=2 sts=2
