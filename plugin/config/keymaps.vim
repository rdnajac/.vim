" keymaps.vim
let g:mapleader = ' '
let g:maplocalleader = '\'

vnoremap <C-s> :sort<CR>

nnoremap <leader>v :e $MYVIMRC<CR>
nnoremap <localleader>w :w<CR>
nnoremap <localleader>x :!./%<CR>
nnoremap <localleader>b :b <C-d>
nnoremap <localleader>f :find<space>
nnoremap <localleader>q :call SmartQuit()<CR>
nnoremap <localleader>r :source $MYVIMRC<CR>
nnoremap <localleader>t :TTags<space>*<space>*<space>.<CR>

function! s:edit_ftplugin()
  execute 'e ' . expand('~/.vim/after/ftplugin/') . &filetype . '.vim'
endfunction
nnoremap <localleader>t :call s:edit_ftplugin()<CR>

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
nnoremap <localleader>h :nohlsearch<CR>
nnoremap <localleader>sl :set list!<CR>:set list?<CR>
nnoremap <localleader>sn :set nornu number!<CR>:set number?<CR>
nnoremap <localleader>sr :set relativenumber!<CR>:set relativenumber?<CR>
nnoremap <localleader>sw :set wrap!<CR>:set wrap?<CR>

function! s:toggle(opt, default)
  execute 'if &'.a:opt.' == '.a:default.' | '.'set '.a:opt.'=0 | '.'else | '.'set '.a:opt.'='.a:default.' | '.'endif '
endfunction

nnoremap <localleader>st :call <SID>toggle('showtabline', 2)<CR>
nnoremap <localleader>ss :call <SID>toggle('laststatus', 2)<CR>
nnoremap <localleader>sc :call <SID>toggle('colorcolumn', 81)<CR>

vnoremap <localleader>r :<C-u>call utils#replaceSelection()<CR>
" double space over word to find and replace
" the angle brackets are word boundaries
" nnoremap <Space><Space> :%s/\<<C-r>=expand("<cword>")<CR>\>/
" vnoremap <Space><Space> y:%s/\<<C-r>=escape(@",'/\')<CR>\>/

" indent/dedent in normal mode with < and >
nnoremap > V`]>
nnoremap < V`]<

" move lines up and down
" nnoremap - ddpkj
" nnoremap _ kddpk
" vnoremap J :m '>+1<CR>gv=gv
" vnoremap K :m '<-2<CR>gv=gv

" easy command line
cnoreabbrev ?? verbose set?<Left>
cnoreabbrev !! !./%

" unmappings
" no Ex mode
nnoremap Q <nop>
" TODO make Q format?

" avoid conflicts with tmux
nnoremap <C-f> <nop>

" paste without overwriting the clipboard
xnoremap <silent> p "_dP
