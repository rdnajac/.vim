scriptencoding utf-8

" Section: settings {{{1
setglobal isfname+=@-@ " from `vim-apathy`
" default: `@,48-57,/,.,-,_,+,,,#,$,%,~,=`
set wildignore+=.DS_Store
set wildignore+=*.o,*.out,*.a,*.so,

set switchbuf+=vsplit

" general {{{2
set jumpoptions+=stack
set mouse=a
set report=0
set scrolloff=8
set shortmess+=aAcCI
set shortmess-=o
set splitbelow splitright
set splitkeep=screen
set timeoutlen=420
set updatetime=69
set virtualedit=block
set whichwrap+=<,>,[,],h,l

" searching {{{2
set ignorecase
set showmatch
set smartcase

" indent {{{2
set breakindent
set linebreak
set nowrap
set shiftround
" don't change tabstop!
set shiftwidth=2 softtabstop=2

augroup vimrc_indent
  autocmd!
  " autocmd FileType markdown,tex    setl sw=2 sts=2
  autocmd FileType cpp,cuda,python setl sw=4 sts=4
  autocmd FileType c,sh,zsh        setl sw=8 sts=8
augroup END

" sesh {{{2
set sessionoptions+=folds
" set sessionoptions-=options   " already default in nvim
set sessionoptions-=blank     " like vim-obsession
set sessionoptions-=tabpages  " per project, not global
set sessionoptions-=terminal  " don't save terminals
set viewoptions-=options      " keep mkview minimal

" ui {{{2
set lazyredraw
set termguicolors
let &laststatus = has('nvim') ? 3 : 2
set statusline=%!vimline#statusline#()

" statuscolumn
" set foldcolumn=1
" set numberwidth=3
" set signcolumn=number
set signcolumn=auto

augroup vimrc_ui
  " no cursorline in insert mode
  au InsertLeave,WinEnter * setlocal cursorline
  au InsertEnter,WinLeave * setlocal nocursorline

  " Hide the statusline while in command mode
  au CmdlineEnter * if &ls != 0            | let g:last_ls = &ls | set ls=0        | endif
  au CmdlineLeave * if exists('g:last_ls') | let &ls = g:last_ls | unlet g:last_ls | endif

  " relative numbers in visual mode only if number is already set
  au ModeChanged [vV\x16]*:* if &l:nu| let &l:rnu = mode() =~# '^[vV\x16]' | endif
  au ModeChanged *:[vV\x16]* if &l:nu| let &l:rnu = mode() =~# '^[vV\x16]' | endif
  au WinEnter,WinLeave *     if &l:nu| let &l:rnu = mode() =~# '^[vV\x16]' | endif
augroup END

" }}}1
" Section: neovim {{{1
if !has('nvim')
  call vimrc#init_vim()
else
  set backup backupext=.bak
  let &backupdir = g:stdpath['state'] . '/backup//'
  let &backupskip .= ',' . expand('$HOME/.cache/*')
  let &backupskip .= ',' . expand('$HOME/.local/*')
  set undofile

  set smoothscroll
  set jumpoptions+=view
  set mousescroll=hor:0
  set nocdhome

  " default on in vim
  set startofline
  " try running `:options` for more...
  hi link vimMap @keyword
  " disable the default popup menu
  aunmenu PopUp | autocmd! nvim.popupmenu
endif
" }}}1
" Section: autocmds {{{1
augroup vimrc
  autocmd!
  au BufWritePre * call vim#mkdir#(expand('<afile>'))
  au BufWritePost vimrc call reload#vimscript(expand('<afile>:p'))
  au BufWritePost */ftplugin/* call reload#ftplugin(expand('<afile>:p'))
  au BufReadPost vimrc call vimrc#setmarks()

  " restore cursor position
  au BufWinEnter * exec "silent! normal! g`\"zv"

  " immediately quit the command line window
  au CmdwinEnter * quit

  " automatically reload files that have been changed outside of Vim
  au FocusGained * if &buftype !=# 'nofile' | checktime | endif

  " automatically resize splits when the window is resized
  au VimResized * let t = tabpagenr() | tabdo wincmd = | execute 'tabnext' t | unlet t

  au VimLeave * if v:dying | echom "help im dying: " . v:dying | endif
augroup END

augroup vimrc_filetype
  autocmd!
  au FileType json,jsonc,json5 setlocal cole=0 et fex=v:lua.nv.json.format()
  au FileType help,qf,nvim-pack nnoremap <buffer> q :lclose<CR><C-W>q
  au FileType lua,json call vim#auto#braces()

  au FileType man setlocal nobuflisted
augroup END

" }}}1
" Section: commands {{{1
command! -nargs=1 Info call vim#notify#info(eval(<q-args>))
command! -nargs=1 Warn call vim#notify#warn(eval(<q-args>))
command! -nargs=1 Error call vim#notify#error(eval(<q-args>))

command! -nargs=* Diff call diff#wrap(<f-args>)

command! -nargs=1 -complete=customlist,scp#complete Scp call scp#(<f-args>)

" }}}1
" Section: keymaps {{{1
nnoremap ` ~
nnoremap ~ `

" TODO: sort opfunc
vmap  :sort<CR>

" `<leader>` {{{2
let g:mapleader = ' '
let g:maplocalleader = '\'

" vim.lsp.hover overrides the default K mapping
nnoremap <leader>q :q!<CR>
nnoremap <leader>Q :wqa!<CR>
nnoremap <leader>E <Cmd>sbp<CR>
nnoremap <leader>K <Cmd>norm! K<CR>
nnoremap <leader>r <Cmd>call sesh#restart()<CR>
nnoremap <leader>R <Cmd>restart!<CR>
nnoremap <leader>S <Cmd>Scriptnames<CR>
nnoremap <leader>m <Cmd>messages<CR>
nnoremap <leader>h <Cmd>Help<CR>
nnoremap <leader>w <Cmd>write!<CR>
nnoremap <leader>! <Cmd>call redir#prompt()<CR>

" file
nnoremap <leader>fD <Cmd>Delete!<Bar>bwipeout #<CR>
nnoremap <leader>fn <Cmd>call file#title()<CR>
nnoremap <leader>fR :set ft=<C-R>=&ft<CR><Bar>Info 'ft reloaded!'<CR>
nnoremap <leader>fs <Cmd>call edit#filetype('snippets/', '.json')<CR>
nnoremap <leader>ft <Cmd>call edit#filetype()<CR>
nnoremap <leader>fT <Cmd>call edit#filetype('.lua')<CR>
nnoremap <leader>fw <Cmd>call format#clean_whitespace()<CR>

" git
nnoremap <leader>ga <Cmd>!git add %<CR>
nnoremap <leader>gN <Cmd>execute '!open' git#url('neovim/neovim')<CR>
nnoremap <leader>gZ <Cmd>execute '!open' git#url('lazyvim/lazyvim')<CR>

nnoremap <leader>vv <Cmd>call edit#vimrc()<CR>

" searching and centering {{{2
" https://github.com/mhinz/vim-galore?tab=readme-ov-file#saner-behavior-of-n-and-n
nmap n nzz
" nnoremap <expr> n  'Nn'[v:searchforward]
xnoremap <expr> n 'Nn'[v:searchforward]
onoremap <expr> n 'Nn'[v:searchforward]

nmap N Nzz
" nnoremap <expr> N  'nN'[v:searchforward]
xnoremap <expr> N 'nN'[v:searchforward]
onoremap <expr> N 'nN'[v:searchforward]

" center searches
nnoremap *  *zzzv
nnoremap #  #zzzv
nnoremap g* g*zzzv
nnoremap g# g#zzzv

" TODO: I forgot what these do...
" nnoremap dp     dp]c
" nnoremap do     do]c

" bookmarks {{{2
nnoremap <Bslash>0  <Cmd>call edit#readme()<CR>
nnoremap <Bslash>i  <Cmd>call edit#(expand('$MYVIMRC'))<CR>
nnoremap <Bslash>v  <Cmd>call edit#vimrc()<CR>

" navigate buffers and windows {{{2
nnoremap <BS> :bprevious<CR>
nnoremap <C-BS> g;

" `<C-e>` scrolls the window downwards by [count] lines
" `<C-^>` (`<C-6>`) which edits the alternate  buffer`:e #`
nnoremap      <C-e>      <C-^>
nnoremap <C-w><C-e> <C-w><C-^>
" see `:h sbp`

for [lhs, rhs] in items({'Left':'h', 'Down':'j', 'Up':'k', 'Right':'l'})
  execute printf('nnoremap <S-%s> <Cmd>wincmd %s<CR>', lhs, rhs)
  execute printf('tnoremap <S-%s> <Cmd>wincmd %s<CR>', lhs, rhs)
endfor

" TODO: S-Tab not detected?
" nnoremap <S-Tab>   <Cmd>wincmd w<CR>
nnoremap <C-q>      <Cmd>wincmd c<CR>
nnoremap <C-w><C-s> <Cmd>sbprevious<CR>
nnoremap <C-w><C-v> <Cmd>vertical +sbprevious<CR>

tnoremap <expr> <C-R> '<C-\><C-N>"'.nr2char(getchar()).'pi'

" just like tmux!
" nnoremap <C-w>-     <C-w>s
" nnoremap <C-w><Bar> <C-w>v

" resize splits
nnoremap <C-W><Up>    :     resize +10<CR>
nnoremap <C-W><Down>  :     resize -10<CR>
nnoremap <C-W><Left>  :vert resize +10<CR>
nnoremap <C-W><Right> :vert resize -10<CR>

" key pairs in normal mode {{{2
" `https://gist.github.com/romainl/1f93db9dc976ba851bbb`
" `cd` cm co cp `cq` `cr` `cs` cu cx cy cz
" `dc` dm dq dr `ds` du dx `dy` dz
" `gb` `gc` `gl` `gs` `gy`
" vm vo vq `vv` vz
" yc `yd` ym `yo` `yp` yq `yr` `ys` `yu` yx yz
" `zq` ZA ... ZP, `ZQ` ... `ZX` `ZZ`

" delete/yank comment
nmap dc dgc
nmap yc ygc

nnoremap cdb <Cmd>cd %:p:h<Bar>pwd<CR>
nnoremap cd- <Cmd>cd -<Bar>pwd<CR>
nnoremap cdp <Cmd>cd %:p:h:h<Bar>pwd<CR>

nnoremap cdP :execute 'edit ' . plug_home . '/' \| pwd<CR>

nmap <expr> cq change#quote()

nnoremap gb vi'"zy:!open https://github.com/<C-R>z<CR>
xnoremap gb    "zy:!open https://github.com/<C-R>z<CR>

" more intuitive `gf` to open file in a new window or jump to the line number
nnoremap <expr> gf &ft !=# '\vmsg<BAR>pager' ? '' : expand('<cWORD>') =~# ':\d\+$' ? 'gF' : 'gf'

" select last changed text (ie pasted text)
nnoremap gV `[V`]

" `fugitive`
nnoremap gcd :Gcd<Bar>pwd<CR>

nnoremap zq <Cmd>Format<CR>
nnoremap ZX <Cmd>Zoxide<CR>

" resursive keymaps
nmap gy "xyygcc"xp<Up>
nmap gY "xyygcc"xP
nmap vv Vgc

" `unimpaired`
nmap zJ ]ekJ

" `surround`
nmap S viWS
vmap ` S`
vmap F Sf

" xmap ga <Plug>(EasyAlign)
" nmap ga <Plug>(EasyAlign)

" TODO: test me!
" change/delete current word {{{2
nnoremap c*   *``cgn
nnoremap c#   *``cgN
nnoremap cg* g*``cgn
nnoremap cg# g*``cgN
nnoremap d*   *``dgn
nnoremap d#   *``dgN
nnoremap dg* g*``dgn
nnoremap dg# g*``dgN

" better indenting {{{2
vnoremap < <gv
vnoremap > >gv
nnoremap > V`]>
nnoremap < V`]<

" insert mode undo breakpoints {{{2
inoremap , ,<C-g>u
inoremap . .<C-g>u
inoremap ; ;<C-g>u

" easier completion  {{{2
inoremap <silent> ,o <C-x><C-o>
" inoremap <silent> ,f <C-x><C-f>
" inoremap <silent> ,i <C-x><C-i>
" inoremap <silent> ,l <C-x><C-l>
" inoremap <silent> ,n <C-x><C-n>
" inoremap <silent> ,t <C-x><C-]>
" inoremap <silent> ,u <C-x><C-u>
inoremap <silent> ,i <Cmd>Icons<CR>

" add chars to EOL {{{2
nnoremap <Bslash>, mzA,<Esc>;`z
nnoremap <Bslash>; mzA;<Esc>;`z
nnoremap <Bslash>. mzA.<Esc>;`z

" insert special chars {{{2
inoremap \sec Section:
iabbrev n- –
iabbrev m- —

" you know what I mean... {{{2
for act in ['c', 'd', 'y'] " change, delete, yank
for obj in ['p', 'w'] " paragraph, word
  execute $'nnoremap {act}{obj} {act}i{obj}'
  execute printf("nnoremap %s%s %si%s", act, toupper(obj), act, toupper(obj))
endfor
endfor

" don't capture whitespace in `gc`
nmap gcap gcip

" }}}1

call plug#begin()
Plug 'alker0/chezmoi.vim'
" Plug 'andymass/vim-matchup'
Plug 'bullets-vim/bullets.vim'
Plug 'justinmk/vim-dirvish'
Plug 'lervag/vimtex'
" Plug 'lervag/wiki.vim.git'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-capslock'
Plug 'tpope/vim-characterize'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-git'
Plug 'tpope/vim-rsi'
" Plug 'tpope/vim-sensible'
Plug 'tpope/vim-scriptease'
Plug 'tpope/vim-tbone'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-vinegar'
if !has('nvim')
Plug 'dense-analysis/ale'
Plug 'dstein64/vim-startuptime'
Plug 'github/copilot.vim'
Plug 'junegunn/vim-easy-align'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
" Plug 'tpope/vim-commentary'
Plug 'wellle/targets.vim'
Plug 'wellle/tmux-complete.vim'
Plug 'AndrewRadev/dsf.vim'
Plug 'AndrewRadev/splitjoin.vim'
Plug 'Konfekt/FastFold'
Plug 'vuciv/golf'
else
Plug 'folke/tokyonight.nvim'
Plug 'saxon1964/neovim-tips'
Plug 'nvim-treesitter/nvim-treesitter-context'
endif
call plug#end() " don't plug#end() if neovim...

if has('nvim')
packadd! nvim.difftool
packadd! nvim.undotree
else
packadd! editorconfig
endif
packadd! nohlsearch

" vim: foldlevelstart=1 foldmethod=marker
