" vim:fdm=marker
scriptencoding utf-8
call vimrc#init()

let g:mapleader = ' '
let g:maplocalleader = '\'

" Section: settings {{{1
" TODO: figure this out
" set autowrite autowriteall
set noswapfile
" set confirm

set ignorecase smartcase
set mouse=a
set pumheight=10
set report=0
set scrolloff=8
set shortmess+=aAcCI
set shortmess-=o
set showmatch
set number
set splitbelow splitright
set splitkeep=screen
set startofline
set timeoutlen=420
set updatetime=69
set whichwrap+=<,>,[,],h,l
" TODO: use ftplugins to set format options
set formatoptions-=or

" editing {{{2
set breakindent
set linebreak
set nowrap
set shiftround
" don't change shiftwidth or tabstop!
" instead, use `sw` and `sts`
set shiftwidth=2
set softtabstop=2

augroup vimrc_indent
  autocmd!
  autocmd FileType markdown,tex    setlocal shiftwidth=2 softtabstop=2
  autocmd FileType cpp,cuda,python setlocal shiftwidth=4 softtabstop=4
  autocmd FileType c,sh,zsh        setlocal shiftwidth=8 softtabstop=8
augroup END

" ui {{{2
set lazyredraw
set termguicolors
set fillchars= " reset
set fillchars+=diff:╱
set fillchars+=eob:\ ,
set fillchars+=stl:\ ,
set list
set listchars= " reset
set listchars+=trail:¿,
set listchars+=tab:→\ ",
set listchars+=extends:…,
set listchars+=precedes:…,
set listchars+=nbsp:+
" }}}1
" Section: autocmds {{{1
augroup vimrc
  autocmd!
  au BufWritePost vimrc call reload#vimscript(expand('<afile>:p'))
  au BufWritePost */ftplugin/* call reload#ftplugin(expand('<afile>:p'))

  " restore cursor position
  au BufWinEnter * exec "silent! normal! g`\"zv"

  " immediately quit the command line window
  au CmdwinEnter * quit

  " automatically reload files that have been changed outside of Vim
  au FocusGained * if &buftype !=# 'nofile' | checktime | endif

  " automatically resize splits when the window is resized
  au VimResized * let t = tabpagenr() | tabdo wincmd = | execute 'tabnext' t

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

  au VimLeave * if v:dying | echom "help im dying: " . v:dying | endif
augroup END

augroup vimrc_filetype
  autocmd!
  au FileType json,jsonc,json5 setlocal conceallevel=0 expandtab
  au FileType help,qf,nvim-pack nnoremap <buffer> q :lclose<CR><C-W>q

  au FileType man setlocal nobuflisted
augroup END
" }}}1
" Section: keymaps {{{1
nmap  ciw
vmap  :sort<CR>
nmap <silent> <C-q> <Cmd>bd<CR>

nnoremap <C-w>- <C-w>s
nnoremap <C-w><Bar> <C-w>v
" nnoremap <C-w>

" key pairs in normal mode {{{2
" `https://gist.github.com/romainl/1f93db9dc976ba851bbb`

" `cd` cm co cp `cq` `cr` `cs` cu cx cy cz
" dc dm dq dr `ds`  du dx `dy` dz
" `gb` `gc` `gl` `gs` `gy`
" vm vo vq `vv` vz
" yc `yd` ym `yo` `yp` yq yr `ys` yu yx yz
" `zq` ZA ... ZP, `ZQ` ... `ZX` `ZZ`

nnoremap ZX <Cmd>Zoxide<CR>

nnoremap cdb <Cmd>cd %:p:h<Bar>pwd<CR>
nnoremap cd- <Cmd>cd -<Bar>pwd<CR>
nnoremap cdp <Cmd>cd %:p:h:h<Bar>pwd<CR>

nnoremap cdP :execute 'edit ' . plug_home . '/' \| pwd<CR>

nmap <expr> cq change#quote()

nnoremap gb vi'"zy:!open https://github.com/<C-R>z<CR>
xnoremap gb    "zy:!open https://github.com/<C-R>z<CR>

" `fugitive`
nnoremap gcd :Gcd<Bar>pwd<CR>

nnoremap zq <Cmd>Format<CR>

" resursive keymaps {{{
nmap gy "xyygcc"xp<Up>
nmap gY "xyygcc"xP
nmap vv Vgc

" `unimpaired`
nmap zJ ]ekJ

" `surround`
nmap S viWS
vmap ` S`

" xmap ga <Plug>(EasyAlign)
" nmap ga <Plug>(EasyAlign)
" }}}

" vim.lsp.hover overrides the default K mapping
nnoremap <leader>K <Cmd>norm! K<CR>
nnoremap <leader>r <Cmd>Restart<CR>
nnoremap <leader>R <Cmd>restart!<CR>
nnoremap <leader>S <Cmd>Scriptnames<CR>
nnoremap <leader>q <Cmd>Quit<CR>
nnoremap <leader>Q <Cmd>Quit!<CR>
nnoremap <leader>m <Cmd>messages<CR>
nnoremap <leader>h <Cmd>Help<CR>
nnoremap <leader>w <Cmd>write!<CR>
nnoremap <leader>! <Cmd>call redir#prompt()<CR>

if has ('nvim')
  nnoremap ,, <Cmd>lua Snacks.picker.buffers()<CR>
  " code
  nnoremap <leader>cc <Cmd>CodeCompanion<CR>
  " debug
  nnoremap <leader>db <Cmd>Blink status<CR>
  nnoremap <leader>dc <Cmd>=vim.lsp.get_clients()[1].server_capabilities<CR>
  nnoremap <leader>dd <Cmd>LazyDev debug<CR>
  nnoremap <leader>dl <Cmd>LazyDev lsp<CR>
  nnoremap <leader>dL <Cmd>=vim.loader._inspect()<CR>
  nnoremap <leader>dh <Cmd>packloadall<Bar>checkhealth<CR>
  nnoremap <leader>dS <Cmd>=require('snacks').meta.get()<CR>
  nnoremap <leader>dw <Cmd>=vim.lsp.buf.list_workspace_folders()<CR>
  nnoremap <leader>dP <Cmd>=vim.pack.get()<CR>
  " git
  nnoremap <leader>gb <Cmd>lua Snacks.picker.git_log_line()<CR>
  nnoremap <leader>gB <Cmd>lua Snacks.gitbrowse()<CR>
  nnoremap <leader>gd <Cmd>lua Snacks.picker.git_diff()<CR>
  nnoremap <leader>gs <Cmd>lua Snacks.picker.git_status()<CR>
  nnoremap <leader>gS <Cmd>lua Snacks.picker.git_stash()<CR>
  nnoremap <leader>ga <Cmd>!git add %<CR>
  nnoremap <leader>gf <Cmd>lua Snacks.picker.git_log_file()<CR>
  nnoremap <leader>gl <Cmd>lua Snacks.picker.git_log()<CR>
  " pickers
  nnoremap <leader>p <Cmd>lua Snacks.picker.resume()<CR>
  nnoremap <leader>P <Cmd>lua Snacks.picker()<CR>
  " file/find/format
  nnoremap <leader>fC <Cmd>lua Snacks.rename.rename_file()<CR>
  nnoremap <leader>ff <Cmd>lua Snacks.picker.files()<CR>
  nnoremap <leader>fr <Cmd>lua Snacks.picker.recent()<CR>
endif

nnoremap <leader>fD <Cmd>Delete!<CR>
nnoremap <leader>fR :set ft=<C-R>=&ft<CR><Bar>Info 'ft reloaded!'<CR>
nnoremap <leader>fn <Cmd>call file#title()<CR>
nnoremap <leader>fw <Cmd>call format#clean_whitespace()<CR>

nnoremap ` ~
vnoremap <BS> d

" buffers {{{2
nnoremap <silent> <S-Tab>       :bprev!<CR>
nnoremap <silent> <Tab>         :bnext!<CR>
nnoremap <silent> <leader><Tab> :e #<CR>
nnoremap <leader>bd <Cmd>lua Snacks.bufdelete()<CR>
nnoremap <leader>bD <Cmd>lua Snacks.bufdelete.other()<CR>

" resize splits {{{2
nnoremap <C-W><Up>    :resize +10<CR>
nnoremap <C-W><Down>  :resize -10<CR>
nnoremap <C-W><Left>  :vertical resize +10<CR>
nnoremap <C-W><Right> :vertical resize -10<CR>

" smarter j/k {{{2
nnoremap <expr> j      v:count == 0 ? 'gj' : 'j'
xnoremap <expr> j      v:count == 0 ? 'gj' : 'j'
nnoremap <expr> k      v:count == 0 ? 'gk' : 'k'
xnoremap <expr> k      v:count == 0 ? 'gk' : 'k'
nnoremap <expr> <Down> v:count == 0 ? 'gj' : 'j'
xnoremap <expr> <Down> v:count == 0 ? 'gj' : 'j'
nnoremap <expr> <Up>   v:count == 0 ? 'gk' : 'k'
xnoremap <expr> <Up>   v:count == 0 ? 'gk' : 'k'

" TODO: check == 0 viml rule
" nnoremap <expr> j v:count ? 'j' : 'gj'
" nnoremap <expr> k v:count ? 'k' : 'gk'
" xnoremap <expr> j v:count ? 'j' : 'gj'
" xnoremap <expr> k v:count ? 'k' : 'gk'

" better n/N {{{2
" https://github.com/mhinz/vim-galore?tab=readme-ov-file#saner-behavior-of-n-and-n {{{
nmap n nzz
" nnoremap <expr> n  'Nn'[v:searchforward]
xnoremap <expr> n  'Nn'[v:searchforward]
onoremap <expr> n  'Nn'[v:searchforward]

nmap N Nzz
" nnoremap <expr> N  'nN'[v:searchforward]
xnoremap <expr> N  'nN'[v:searchforward]
onoremap <expr> N  'nN'[v:searchforward]

" center searches {{{2
nnoremap *  *zzzv
nnoremap #  #zzzv
nnoremap g* g*zzzv
nnoremap g# g#zzzv

" lervag/dotfiles " {{{2
" already in nivm
" nnoremap Y      y$
" nnoremap '      `

" TODO: 
nnoremap J      mzJ`z
nnoremap dp     dp]c
nnoremap do     do]c

" TODO: vim
" nnoremap <c-e>       <c-^>
" nnoremap <c-w><c-e>  <c-w><c-^>
nnoremap gV     `[V`]

" lile tmux!
" nnoremap <c-w>-     <c-w>s
" nnoremap <c-w><bar> <c-w>v

" Buffer navigation
" nnoremap <silent> gb    :bnext<cr>
" nnoremap <silent> gB    :bprevious<cr>

" Navigate folds
nnoremap          zv zMzvzz
nnoremap <silent> zj zcjzOzz
nnoremap <silent> zk zckzOzz

" Backspace and return for improved navigation
nnoremap        <bs> <c-o>zvzz

" Utility maps for repeatable quickly change/delete current word
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

" easier completion {{{2
" inoremap <silent> <Bslash>o <C-x><C-o>
" inoremap <silent> <Bslash>f <C-x><C-f>
" inoremap <silent> <Bslash>i <C-x><C-i>
" inoremap <silent> <Bslash>l <C-x><C-l>
" inoremap <silent> <Bslash>n <C-x><C-n>
" inoremap <silent> <Bslash>t <C-x><C-]>
" inoremap <silent> <Bslash>u <C-x><C-u>
inoremap <silent> ,i <Cmd>Icons<CR>

" add chars to EOL {{{2
nnoremap <Bslash>, mzA,<Esc>;`z
nnoremap <Bslash>; mzA;<Esc>;`z

" unimpaired {{{2
" exchange lines
nnoremap ]e :execute 'move .+' . v:count1<CR>==
" inoremap ]e <Esc>:m .+1<CR>==gi
vnoremap ]e :<C-u>execute "'<,'>move '>+" . v:count1<CR>gv=gv
nnoremap [e :execute 'move .-' . (v:count1 + 1)<CR>==
" inoremap [e <Esc>:m .-2<CR>==gi
vnoremap [e :<C-u>execute "'<,'>move '<-" . (v:count1 + 1)<CR>gv=gv

" insert special chars {{{2
inoremap \sec Section:
iabbrev n- –
iabbrev m- —
" }}}1
" Section: commands {{{1
command! -nargs=1 Info call vim#notify#info(eval(<q-args>))
command! -nargs=1 Warn call vim#notify#warn(eval(<q-args>))
command! -nargs=1 Error call vim#notify#error(eval(<q-args>))
" }}}
" Section: ui {{{1
" TODO: move to col.vim or something
" set foldcolumn=1
set signcolumn=number
" set numberwidth=3

let &laststatus = has('nvim') ? 3 : 2
set statusline=%!vimline#statusline#()

" TODO: move to nv.ui
" set statuscolumn=%!vimline#statuscolumn#()
" set statuscolumn=%!v:lua.require'vimline.statuscolumn'()
" set statuscolumn=%{if(&number,printf('%4d',v:lnum),repeat(' ',4)).'│'}
" }}}1
" globals for plugin configuration {{{1
let g:vimtex_format_enabled = 1

" FIXME: doesn't work well with r files
" https://github.com/tpope/vim-eunuch/blob/master/doc/eunuch.txt
let g:interpreters = {
      \ '.':      '/bin/sh',
      \ 'sh':     '/bin/bash',
      \ 'bash':   'bash',
      \ 'r':      'Rscript',
      \ 'zsh':    'zsh',
      \ 'lua':    'lua',
      \ 'python': 'python3',
      \ 'rmd':    'Rscript',
      \ }

" }}}1

" Section: plugins {{{ 1
call plug#begin()
Plug 'alker0/chezmoi.vim'
Plug 'lervag/vimtex'
" Plug 'lervag/wiki.vim.git'
" Plug 'github/copilot.vim'
Plug 'tpope/vim-git'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-scriptease'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-tbone'
Plug 'tpope/vim-endwise'
" Plug 'tpope/vim-rsi'
" Plug 'tpope/vim-abolish'
" Plug 'tpope/vim-capslock'
" Plug 'tpope/vim-characterize'
" Plug 'tpope/vim-dispatch'
" Plug 'tpope/vim-unimpaired'
Plug 'AndrewRadev/dsf.vim'
Plug 'AndrewRadev/splitjoin.vim'
Plug 'bullets-vim/bullets.vim'
Plug 'vuciv/golf'
" Plug '~/GitHub/rdnajac/vim-lol'
if !has('nvim') " {{{
  Plug 'dense-analysis/ale' " TODO: try nvim-lint
  Plug 'github/copilot.vim'
  Plug 'Konfekt/FastFold'
  Plug 'junegunn/vim-easy-align'
  " Plug 'tpope/vim-sensible'
  Plug 'tpope/vim-vinegar'
  " TODO: try the shipped vim9 comment plugin
  Plug 'tpope/vim-commentary'
  " }}}
else " neovim plugins {{{
  Plug 'folke/snacks.nvim'
  Plug 'folke/tokyonight.nvim'
  Plug 'folke/which-key.nvim'
  " Plug 'folke/flash.nvim'
  Plug 'stevearc/oil.nvim'
  Plug 'nvim-mini/mini.nvim'
  " TODO: load these automatically from module specs
  Plug 'R-nvim/r.nvim'
  Plug 'MeanderingProgrammer/render-markdown.nvim'
  Plug 'mason-org/mason.nvim'
  Plug 'Saghen/blink.cmp'
  Plug 'monaqa/dial.nvim'
  " Plug 'stevearc/conform.nvim'
  " }}}
endif
call plug#end() " }}}1

if !exists('g:vimrc_reload_count')
  let g:vimrc_reload_count = 0
else
  let g:vimrc_reload_count += 1
  Info 'Reloaded vimrc [' . g:vimrc_reload_count . ']'
endif
