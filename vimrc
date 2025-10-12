scriptencoding utf-8
let g:mapleader = ' '
let g:maplocalleader = '\'
call vimrc#init()

let &laststatus = has('nvim') ? 3 : 2
set statusline=%!vimline#statusline()

" Section: settings {{{1
set noswapfile
" set autowrite autowriteall
" set confirm

set mouse=a
set report=0
set scrolloff=8
set shortmess+=aAcCI
set shortmess-=o
set splitbelow splitright
set splitkeep=screen
set startofline
set timeoutlen=420
set updatetime=69
set whichwrap+=<,>,[,],h,l
set virtualedit=block

" text {{{
set breakindent
set linebreak
set nowrap
set shiftround
" don't change tabstop! use `sw` and `sts`
set shiftwidth=2
set softtabstop=2

augroup vimrc_indent
  autocmd!
  autocmd FileType markdown,tex    setlocal shiftwidth=2 softtabstop=2
  autocmd FileType cpp,cuda,python setlocal shiftwidth=4 softtabstop=4
  autocmd FileType c,sh,zsh        setlocal shiftwidth=8 softtabstop=8
augroup END

" searching {{{
set showmatch
set ignorecase
set smartcase

" ui {{{
" set pumheight=10
set number
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

" folding {{{
set fillchars+=fold:\ ,
set fillchars+=foldclose:▸,
set fillchars+=foldopen:▾,
set fillchars+=foldsep:\ ,
set fillchars+=foldsep:│
set foldlevel=99
" set foldlevelstart=2
" set foldminlines=5
set foldopen+=insert,jump
set foldtext=fold#text()
" set foldmethod=marker

augroup vimrc_fold
  au!
  au FileType sh  setl fdm=expr
  au FileType vim setl fdm=marker
augroup END

" open and closed folds with `h` in normal mode
nnoremap <expr> h fold#open_or_h()

" better search if auto pausing folds
" set foldopen-=search
" nnoremap <silent> / zn/

" sesh {{{
set sessionoptions+=folds
" set sessionoptions-=options   " already default in nvim
set sessionoptions-=blank     " like vim-obsession
set sessionoptions-=tabpages  " per project, not global
set sessionoptions-=terminal  " don't save terminals
set viewoptions-=options      " keep mkview minimal
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

  " no numbers in split
  " au WinEnter * setlocal number
  " au WinLeave * setlocal nocursorline

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
" shortcuts! {{{
nnoremap <Bslash>0 <Cmd>call edit#readme()<CR>
nnoremap <BSlash>i <Cmd>call edit#('~/.config/nvim/init.lua')<CR>
nnoremap <BSlash>n <Cmd>call edit#luamod('nvim/init')<CR>
nnoremap <BSlash>s <Cmd>call edit#luamod('nvim/snacks')<CR>
nnoremap <BSlash>c <Cmd>call edit#luamod('nvim/config')<CR>
nnoremap <BSlash>p <Cmd>call edit#luamod('nvim/util/plug')<CR>
nnoremap <BSlash>m <Cmd>call edit#luamod('nvim/plugins/mini')<CR>
nnoremap <BSlash>u <Cmd>call edit#luamod('nvim/util/init')<CR>
" nnoremap <BSlash>k <Cmd>call edit#luamod('nvim/config/keymaps')<CR>

nnoremap <leader>ft <Cmd>call edit#filetype()<CR>
nnoremap <leader>fT <Cmd>call edit#filetype('/after/ftplugin/', '.lua')<CR>
nnoremap <leader>fs <Cmd>call edit#filetype('snippets/', '.json')<CR>

nnoremap <leader>vv <Cmd>call edit#vimrc()<CR>
" TODO: find thecode for automatic marks
function! s:autosection() abort
  let l:vimrc = vimrc#home() . '/vimrc'
  for l:line in readfile(l:vimrc)
    if l:line =~? '^"\s*Section:\s*'
      let l:idx = matchend(l:line, '^"\s*Section:\s*')
      let l:ch  = strcharpart(l:line, l:idx, 1)
      execute printf("nnoremap <silent> <leader>v%s :call edit#vimrc('\+\/Section:\\ %s')<CR>", l:ch, l:ch)
    endif
  endfor
endfunction
call s:autosection()

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

nnoremap cdP :execute 'edit ' . plug_dir . '/' \| pwd<CR>

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
vmap F Sf

" xmap ga <Plug>(EasyAlign)
" nmap ga <Plug>(EasyAlign)
" }}}

" vim.lsp.hover overrides the default K mapping
nnoremap <leader>K <Cmd>norm! K<CR>
nnoremap <leader>r <Cmd>Restart<CR>
nnoremap <leader>R <Cmd>restart!<CR>
nnoremap <leader>S <Cmd>Scriptnames<CR>
nnoremap <leader>q <Cmd>quit<CR>
nnoremap <leader>Q <Cmd>Quit!<CR>
nnoremap <leader>m <Cmd>messages<CR>
nnoremap <leader>N <Cmd>lua Snacks.picker.notifications()<CR>
" nnoremap <leader>N <Cmd>lua Snacks.notifier.show_history()<CR>
" nnoremap <leader>ff <Cmd>lua Snacks.picker.files()<CR>
nnoremap <leader>h <Cmd>Help<CR>
nnoremap <leader>w <Cmd>write!<CR>
nnoremap <leader>! <Cmd>call redir#prompt()<CR>

if has ('nvim')
  " code
  nnoremap <leader>cm <Cmd>Mason<CR>
  " debug
  nnoremap <leader>db <Cmd>Blink status<CR>
  nnoremap <leader>dc <Cmd>=vim.lsp.get_clients()[1].server_capabilities<CR>
  nnoremap <leader>dd <Cmd>LazyDev debug<CR>
  nnoremap <leader>dl <Cmd>LazyDev lsp<CR>
  nnoremap <leader>dL <Cmd>=require('lualine').get_config()<CR>
  nnoremap <leader>dh <Cmd>packloadall<Bar>checkhealth<CR>
  nnoremap <leader>dS <Cmd>=require('snacks').meta.get()<CR>
  nnoremap <leader>dw <Cmd>=vim.lsp.buf.list_workspace_folders()<CR>
  nnoremap <leader>dD <Cmd>=nv.did<CR>
  " nnoremap <leader>dD <Cmd>=nv.did<CR>
  nnoremap <leader>dP <Cmd>=vim.tbl_keys(package.loaded)<CR>
  nnoremap <leader>dR <Cmd>=require('r.config').get_config()<CR>
endif
nnoremap <leader>fD <Cmd>Delete!<Bar>bwipeout #<CR>
nnoremap <leader>fR :set ft=<C-R>=&ft<CR><Bar>Info 'ft reloaded!'<CR>
nnoremap <leader>fn <Cmd>call file#title()<CR>
nnoremap <leader>fw <Cmd>call format#clean_whitespace()<CR>

" git
nnoremap <leader>ga <Cmd>!git add %<CR>
nnoremap <leader>gN <Cmd>execute '!open' git#url('neovim/neovim')<CR>
nnoremap <leader>gZ <Cmd>execute '!open' git#url('lazyvim/lazyvim')<CR>

nnoremap ` ~
nnoremap ~ `

nnoremap  <leader><Tab> <Cmd>e #<CR>

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

" like tmux!
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
command! Restart call sesh#restart()

" }}}1
" Section: ui {{{1
" set foldcolumn=1
set signcolumn=number
" set numberwidth=3

" }}}1
" Section: global variables {{{1
let g:vimtex_format_enabled = 1

" FIXME: doesn't work well with r files
" https://github.com/tpope/vim-eunuch/blob/master/doc/eunuch.txt
let g:interpreters = {
      \ '.':      '/bin/sh',
      \ 'sh':     '/bin/bash',
      \ 'bash':   'bash',
      \ 'lua':    'lua',
      \ 'python': 'python3',
      \ 'r':      'Rscript',
      \ 'rmd':    'Rscript',
      \ 'zsh':    'zsh',
      \ 'nv':     'nvim -l',
      \ }

" }}}1
" Section: plugins {{{ 1
call plug#begin()
Plug 'alker0/chezmoi.vim'
Plug 'lervag/vimtex'
" Plug 'lervag/wiki.vim.git'
" Plug 'tpope/vim-abolish'
" Plug 'tpope/vim-capslock'
" Plug 'tpope/vim-characterize'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-git'
Plug 'tpope/vim-repeat'
" Plug 'tpope/vim-rsi'
Plug 'tpope/vim-surround'
" Plug 'tpope/vim-tbone'
" Plug 'tpope/vim-unimpaired'
" Plug 'andymass/vim-matchup'
" Plug 'bullets-vim/bullets.vim'
Plug 'vuciv/golf'
" ruby
Plug 'AndrewRadev/dsf.vim'
Plug 'AndrewRadev/splitjoin.vim'
if !has('nvim')
  Plug 'dense-analysis/ale'
  Plug 'github/copilot.vim'
  Plug 'junegunn/vim-easy-align'
  Plug 'tpope/vim-commentary'
  " Plug 'tpope/vim-scriptease'
  " Plug 'tpope/vim-sensible'
  Plug 'tpope/vim-vinegar'
  Plug 'welle/targets.vim'
  Plug 'welle/tmux-complete.vim'
  Plug 'Konfekt/FastFold'
else
  Plug 'saxon1964/neovim-tips'
endif
call plug#end() " }}}1

if !exists('g:loaded_vimrc')
  let g:loaded_vimrc = 1
else
  let g:loaded_vimrc+= 1 | Info 'Reloaded vimrc [' . g:loaded_vimrc . ']'
endif
" vim:foldlevelstart=1:fdm=marker
