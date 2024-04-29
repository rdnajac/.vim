" vim: fdm=marker fdl=1

" under the hood {{{2
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

if !has('nvim')
  syntax enable                   " prefer `:syntax enable` over `:syntax on
  set autoindent smarttab         " enable auto-indent and smart tabbing
  set autoread                    " auto reload files when changed outside of vim
  set backspace=indent,eol,start  " backspace behavior
  set encoding=utf-8              " nvim default is utf-8
  set formatoptions+=j            " delete comment character when joining lines
  set hidden                      " enable background buffers
  set hlsearch incsearch          " highlighted, incremental search
  set mouse=a                     " enable mouse in all modes
  set nocompatible                " vim behaves like vim, not like vi
  set noerrorbells novisualbell   " disable error bells and visual bells
  if exists(':Man') != 2 && !exists('g:loaded_man') && &filetype !=? 'man'
    runtime ftplugin/man.vim
  endif
  set clipboard=unnamed
else
  set clipboard=unnamedplus
  "set noshowmode      " disable showmode
  "set noshowcmd       " disable showcmd
  "set noruler         " disable ruler
endif
" searh and matching {{{3
set ignorecase smartcase
"set matchtime=2  " default is 5
set iskeyword+=-  " treat hyphens as part of a word
"set iskeyword+=_  " treat underscores as part of a word
" }}}3
" display settings {{{3
set background=dark termguicolors
set cursorline
set number numberwidth=3 relativenumber
set pumheight=10
set showmatch
set signcolumn=yes
set splitbelow splitright
" }}}3
" undofile {{{3
set undofile noswapfile
set undolevels=1000
set undoreload=10000
if !has('nvim')
  if !isdirectory(expand("~/.vim/.undo"))
    call mkdir(expand("~/.vim/.undo"), "p", 0700)
  endif
  let &undodir=expand("~/.vim/.undo")
endif
" }}}3
" ignore these patterns {{{3
set wildignore+=
      \*.exe,*.out,*.cm*,*.o,*.a,*.so,*.dll,*.dylib,*.lib,*.bin,*.app,*.apk,*.dmg,*.iso,*.msi,*.deb,*.rpm,*.pkg,
      \*.class,*.jar,*.pyo,*.pyd,*.node,*.swp,*.swo,*.tmp,*.temp,*.DS_Store,Thumbs.db,
      \*/.git/*,*/.hg/*,*/.svn/*,
      \*.pdf,*.aux,*.fdb_latexmk,*.fls,
      \*.jpg,*.png,*.gif,*.bmp,*.tiff,*.ico,*.svg,*.webp,*.img,
      \*.mp3,*.mp4,*.avi,*.mkv,*.mov,*.flv,*.wmv,*.webm,*.m4v,*.flac,*.wav,
      \*.zip,*.tar.gz,*.rar,*.7z,*.tar.xz,*.tgz,
      \*/node_modules/*,*/vendor/*,*/build/*,*/dist/*,*/out/*,*/bin/*,*/.vscode/*,*/__pycache__/*,*/.cache/*

" }}}3
" }}}
" key mappings {{{1
let mapleader = "\<space>"

nnoremap ? :call GetInfo()<cr>

nnoremap <leader>w :w<cr>
nnoremap <leader>Q :qa!<cr>
" nnoremap <leader>ev :vs $MYVIMRC<cr>
" instead, edit the experimental settings
nnoremap <leader>ev :vs ~/.vim/xvimrc.vim<cr>
nnoremap <leader>h :set hlsearch!<cr>
nnoremap <leader>t :set list!<cr>
nnoremap <leader>o i<cr><esc>

" indent/dedent visual block
nnoremap > V`]>
nnoremap < V`]<

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

" which-key {{{3
let g:which_key_map =  {}
"nnoremap <silent> <leader> :<c-u>WhichKey '<Space>'<CR>
"vnoremap <silent> <leader> :<c-u>WhichKeyVisual '<Space>'<CR>
"call which_key#register('<Space>', "g:which_key_map")

let g:which_key_map['f'] = {
      \ 'name' : '+fzf/find/' ,
      \ 'f' : [':Files<cr>' , 'files'],
      \ 'g' : [':GFiles<cr>' , 'git files'],
      \ 'b' : [':Buffers<cr>' , 'buffers'],
      \ 'h' : [':History<cr>' , 'history'],
      \ 'm' : [':Marks<cr>' , 'marks'],
      \ 't' : [':Tags<cr>' , 'tags'],
      \ }
call which_key#register('f', "g:which_key_map")

let g:which_key_map['g'] = {
      \ 'name' : '+git' ,
      \ 'b' : [':Git blame<cr>' , 'blame'],
      \ 'c' : [':Git commit<cr>' , 'commit'],
      \ 'd' : [':Git diff<cr>' , 'diff'],
      \ 'e' : [':Git edit<cr>' , 'edit'],
      \ 'l' : [':Git log<cr>' , 'log'],
      \ 'r' : [':Git read<cr>' , 'read'],
      \ 's' : [':Git status<cr>' , 'status'],
      \ 'w' : [':Git write<cr>' , 'write'],
      \ 'p' : [':Git push<cr>' , 'push'],
      \ 'P' : [':Git pull<cr>' , 'pull'],
      \ 'm' : [':Git merge<cr>' , 'merge'],
      \ }
call which_key#register('g', "g:which_key_map")
" }}}3

" plugin config {{{1


au FileType help,man,netrw,quickfix silent! nnoremap <silent> <buffer> q :close<CR> | set nobuflisted
"au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g'\"zv" | endif
au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g'\"" | if winline() >= winheight(0) - 3 | exe "normal! zb" | endif | endif
let g:vimtex_view_method='skim'

let g:EditorConfig_exclude_patterns = ['fugitive://.*']

" }}}1

augroup ReloadFil e
  autocmd!
  autocmd FocusGained * :checktime
augroup END

" function! VisualSearch()
"   let temp = @s
"   normal! gvy
"   let @/ = '\V' . escape(@s, '\')
"   let @s = temp
"   normal! /
" endfunction
" vnoremap <leader>f :<c-u>call VisualSearch()<cr>
" one-liner:
vnoremap <leader>f :<c-u>let @/ = '\V' . escape(@s, '\')<cr>

function SourceXvimrc()
  source $HOME/.vim/xvimrc.vim
  let l:cat = ">^.^< "
  echo "xvimrc sourced " . l:cat
endfunction
nnoremap <leader>r :call SourceXvimrc()<cr>

vnoremap <leader>s <plug>VSurround

" map to leader f
runtime xvimrc.vim " load experimental settings

