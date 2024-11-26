" keymaps.vim
let g:mapleader = ' '
let g:maplocalleader = '\'

" paste without overwriting the clipboard
xnoremap <silent> p "_dP

vnoremap <C-s> :sort<CR>

nnoremap <leader>b :b <C-d>
nnoremap <leader>f :find<space>
nnoremap <leader>h :nohlsearch<CR>
nnoremap <leader>i :execute 'verbose set '.expand("<cword>")<CR>
nnoremap <leader>q :call SmartQuit()<CR>
nnoremap <leader>r :source $MYVIMRC<CR>
" nnoremap <leader>t :TTags<space>*<space>*<space>.<CR>

nnoremap <leader>t :execute "e " . expand("~/.vim/after/ftplugin/") . &filetype . ".vim"<CR>
nnoremap <leader>v :e $MYVIMRC<CR>
nnoremap <leader>w :w<CR>
nnoremap <leader>x :!./%<CR>

" buffer/window navigation
nnoremap <tab> :bnext<CR>
nnoremap <s-tab> :bprevious<CR>
nnoremap <leader><tab> :b#<CR>

" better escape with jk/kj {{{2
inoremap jk <esc>
inoremap kj <esc>
vnoremap jk <esc>
vnoremap kj <esc>
" }}}

" better completion {{{2
inoremap <silent> <localleader>o <C-x><C-o>
inoremap <silent> <localleader>f <C-x><C-f>
inoremap <silent> <localleader>i <C-x><C-i>
inoremap <silent> <localleader>l <C-x><C-l>
inoremap <silent> <localleader>n <C-x><C-n>
inoremap <silent> <localleader>t <C-x><C-]>
inoremap <silent> <localleader>u <C-x><C-u>
" }}}

" center searches {{{2
nnoremap n nzzzv
nnoremap N Nzzzv
nnoremap * *zzzv
nnoremap # #zzzv
nnoremap g* g*zzzv
nnoremap g# g#zzzv
" }}}

" toggle settings
nnoremap <leader>sl :set list!<CR>:set list?<CR>
nnoremap <leader>sn :set nornu number!<CR>:set number?<CR>
nnoremap <leader>sr :set relativenumber!<CR>:set relativenumber?<CR>
nnoremap <leader>sw :set wrap!<CR>:set wrap?<CR>

function! s:toggle(opt, default)
  execute 'if &'.a:opt.' == '.a:default.' | '.'set '.a:opt.'=0 | '.'else | '.'set '.a:opt.'='.a:default.' | '.'endif '
endfunction

nnoremap <leader>st :call <SID>toggle('showtabline', 2)<CR>
nnoremap <leader>ss :call <SID>toggle('laststatus', 2)<CR>
nnoremap <leader>sc :call <SID>toggle('colorcolumn', 81)<CR>

" indent/dedent in normal mode with < and >
nnoremap > V`]>
nnoremap < V`]<

" move lines up and down
nnoremap - ddpkj
nnoremap _ kddpk
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

" easy command line
cnoreabbrev ?? verbose set?<Left>
cnoreabbrev !! !./%


" unmappings
" no Ex mode
nnoremap Q <nop>
" TODO make Q format?

" avoid conflicts with tmux
nnoremap <C-f> <nop>
