scriptencoding=utf-8
call vim#rc()

let g:mapleader = ' '
let g:maplocalleader = '\'

" Section: settings {{{1
" TODO: figure this out
" set autowrite autowriteall
set noswapfile
set confirm

set ignorecase smartcase
set mouse=a
set pumheight=10
set report=0
set scrolloff=8
set shortmess+=aAcCI
set shortmess-=o
set showmatch
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
set listchars+=extends:>,
set listchars+=precedes:<,
set listchars+=nbsp:+

" set foldcolumn=1
set number
set numberwidth=4
set signcolumn=number
" }}}1

" Section: autocmds {{{1
augroup vimrc
  autocmd!
  " au BufWritePost vimrc call vim#notify#info('Sourced vimrc!')
  au BufWritePost vimrc call reload#vimscript(expand('<afile>:p'))
  au BufWritePost */ftplugin/* call reload#ftplugin(expand('<afile>:p'))

  " restore cursor position
  au BufWinEnter * exec "silent! normal! g`\"zv"

  " automatically create directories for new files
  " requires `vim-eunuch`
  " FIXME: use the vim fn
  au BufWritePre ~/ silent! Mkdir

  " immediately quit the command line window
  au CmdwinEnter * quit

  " automatically reload files that have been changed outside of Vim
  au FocusGained * if &buftype !=# 'nofile' | checktime | endif

  " automatically resize splits when the window is resized
  au VimResized * let t = tabpagenr() | tabdo wincmd = | execute 'tabnext' t

  " no cursorline in insert mode
  au InsertLeave,WinEnter * setlocal cursorline
  au InsertEnter,WinLeave * setlocal nocursorline

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

" key pairs in normal mode {{{2
" `https://gist.github.com/romainl/1f93db9dc976ba851bbb`

" `cd` cm co cp `cq` `cr` `cs` cu cx cy cz
" dc dm dq dr `ds`  du dx `dy` dz
" `gb` `gc` `gl` `gs` `gy`
" vm vo vq `vv` vz
" yc `yd` ym `yo` `yp` yq yr `ys` yu yx yz

" `zq` ZA ... ZP, `ZQ` ... `ZX` `ZZ`
nnoremap ZX <Cmd>Zoxide<CR>

" nnoremap cdb :cd %:p:h<CR>
nnoremap cdb <Cmd>cd %:p:h<Bar>pwd<CR>
nnoremap cd- <Cmd>cd %:p:h<Bar>pwd<CR>
nnoremap cdp <Cmd>cd %:p:h:h<Bar>pwd<CR>
nnoremap cdh <Cmd>cd<Bar>pwd<CR>
nnoremap cdg :cd<C-R>=git#root()<CR><Bar>pwd<CR>
nnoremap cdc :cd<C-R>=git#root()<CR><Bar>pwd<CR>

nnoremap <expr> cq change#quote()

nnoremap gb vi'"zy:!open https://github.com/<C-R>z<CR>
xnoremap gb    "zy:!open https://github.com/<C-R>z<CR>

" `fugitive`
nnoremap gcd :Gcd<Bar>pwd<CR>

nnoremap zq <Cmd>Format<CR>

" resursive keymaps {{{
nmap gy "xyygcc"xp
nmap vv Vgc

" `unimpaired`
nmap zJ ]ekJ

" `surround`
nmap S viWS
vmap ` S`
" }}}

nnoremap ,, <Cmd>lua Snacks.picker.buffers()<CR>
nnoremap <leader>! <Cmd>call redir#prompt()<CR>
nnoremap <leader><Space> viW

" vim.lsp.hover overrides the default K mapping
nnoremap <leader>K  <Cmd>norm! K<CR>

nnoremap <leader>e <Cmd>Explore<CR>
nnoremap <leader>r <Cmd>Restart<CR>
nnoremap <leader>R <Cmd>restart!<CR>

nnoremap <leader>S <Cmd>Scriptnames<CR>
nnoremap <leader>. <Cmd>Scratch<CR>
nnoremap <leader>q <Cmd>Quit<CR>
nnoremap <leader>Q <Cmd>Quit!<CR>
nnoremap <leader>> <Cmd>Scratch!<CR>
nnoremap <leader>i <Cmd>help index<CR>
nnoremap <leader>m <Cmd>messages<CR>
nnoremap <leader>h <Cmd>Help<CR>
nnoremap <leader>t <Cmd>edit #<CR>
nnoremap <leader>w <Cmd>write!<CR>
nnoremap <leader>z <Cmd>Zoxide<CR>
nnoremap <leader>/ <Cmd>lua Snacks.picker.grep()<CR>
nnoremap <leader>bd <Cmd>lua Snacks.bufdelete()<CR>
nnoremap <leader>bD <Cmd>lua Snacks.bufdelete.other()<CR>

" code {{{2
" https://github.com/mhinz/vim-galore?tab=readme-ov-file#quickly-edit-your-macros
" nnoremap <leader>M  :<c-u><c-r>V-r>='let @'. v:register .' = '. string(getreg(v:register))<cr><c-f><left>
" nnoremap <expr> <leader>M ':let @'.v:register.' = '.string(getreg(v:register))."\<CR>\<C-f>\<Left>"

" debug {{{2
nnoremap <leader>db <Cmd>Blink status<CR>
nnoremap <leader>dc <Cmd>=vim.lsp.get_clients()[1].server_capabilities<CR>
nnoremap <leader>dd <Cmd>LazyDev debug<CR>
nnoremap <leader>dl <Cmd>LazyDev lsp<CR>
nnoremap <leader>dh <Cmd>packloadall<Bar>checkhealth<CR>
nnoremap <leader>dS <Cmd>=require('snacks').meta.get()<CR>
nnoremap <leader>dw <Cmd>=vim.lsp.buf.list_workspace_folders()<CR>
nnoremap <leader>dP <Cmd>=vim.pack.get()<CR>

" file/find/format {{{2
nnoremap <leader>fC <Cmd>lua Snacks.rename.rename_file()<CR>
nnoremap <leader>ff <Cmd>lua Snacks.picker.files()<CR>
nnoremap <leader>fr <Cmd>lua Snacks.picker.recent()<CR>
nnoremap <leader>fD <Cmd>Delete!<CR>
nnoremap <leader>fR <Cmd>set ft=<C-R>=&ft<CR><CR>
nnoremap <leader>fn <Cmd>call file#title()<CR>
nnoremap <leader>fw <Cmd>call format#clean_whitespace()<CR>

" git {{{2
nnoremap <leader>gb <Cmd>lua Snacks.picker.git_log_line()<CR>
nnoremap <leader>gB <Cmd>lua Snacks.gitbrowse()<CR>
nnoremap <leader>gd <Cmd>lua Snacks.picker.git_diff()<CR>
nnoremap <leader>gs <Cmd>lua Snacks.picker.git_status()<CR>
nnoremap <leader>gS <Cmd>lua Snacks.picker.git_stash()<CR>
nnoremap <leader>ga <Cmd>!git add %<CR>
nnoremap <leader>gg <Cmd>lua Snacks.lazygit()<CR>
nnoremap <leader>gf <Cmd>lua Snacks.picker.git_log_file()<CR>
nnoremap <leader>gl <Cmd>lua Snacks.picker.git_log()<CR>

" pickers {{{2
nnoremap <leader>p <Cmd>lua Snacks.picker.resume()<CR>
nnoremap <leader>P <Cmd>lua Snacks.picker()<CR>
nnoremap <leader>n <Cmd>lua Snacks.picker.notifications()<CR>

" search
nnoremap <leader>s" <Cmd>lua Snacks.picker.registers()<CR>
nnoremap <leader>s/ <Cmd>lua Snacks.picker.search_history()<CR>
nnoremap <leader>s: <Cmd>lua Snacks.picker.command_history()<CR>
nnoremap <leader>sd <Cmd>lua Snacks.picker.diagnostics()<CR>
nnoremap <leader>sj <Cmd>lua Snacks.picker.jumps()<CR>
nnoremap <leader>sq <Cmd>lua Snacks.picker.qflist()<CR>
nnoremap <leader>sh <Cmd>lua Snacks.picker.help()<CR>
nnoremap <leader>sH <Cmd>lua Snacks.picker.highlights()<CR>
nnoremap <leader>si <Cmd>lua Snacks.picker.icons()<CR>
nnoremap <leader>su <Cmd>lua Snacks.picker.undo()<CR>

" XXX: potential conflicts
nnoremap ` ~
nnoremap <BS> <C-o>
vnoremap <BS> d

" text objects {{{2
" Buffer pseudo-text objects
xnoremap ig :<C-u>let z = @/\|1;/^./kz<CR>G??<CR>:let @/ = z<CR>V'z
onoremap ig :<C-u>normal vig<CR>
xnoremap ag GoggV
onoremap ag :<C-u>normal vag<CR>

" buffers {{{2
nnoremap <silent> <S-Tab>       :bprev!<CR>
nnoremap <silent> <Tab>         :bnext!<CR>
nnoremap <silent> <leader><Tab> :e #<CR>

" resize splits {{{2
" nnoremap <M-Up>    :resize -2<CR>
" nnoremap <M-Down>  :resize +2<CR>
nnoremap <M-Left>  :vertical resize -2<CR>
nnoremap <M-Right> :vertical resize +2<CR>

" smarter j/k {{{2
nnoremap <expr> j      v:count == 0 ? 'gj' : 'j'
xnoremap <expr> j      v:count == 0 ? 'gj' : 'j'
nnoremap <expr> k      v:count == 0 ? 'gk' : 'k'
xnoremap <expr> k      v:count == 0 ? 'gk' : 'k'
nnoremap <expr> <Down> v:count == 0 ? 'gj' : 'j'
xnoremap <expr> <Down> v:count == 0 ? 'gj' : 'j'
nnoremap <expr> <Up>   v:count == 0 ? 'gk' : 'k'
xnoremap <expr> <Up>   v:count == 0 ? 'gk' : 'k'

" better n/N {{{2
" https://github.com/mhinz/vim-galore?tab=readme-ov-file#saner-behavior-of-n-and-n {{{
" normal mode also openz folds and centers the cursor
nnoremap <expr> n ('Nn'[v:searchforward]) . 'zvzz'
xnoremap <expr> n  'Nn'[v:searchforward]
onoremap <expr> n  'Nn'[v:searchforward]

nnoremap <expr> N ('nN'[v:searchforward]) . 'zvzz'
xnoremap <expr> N  'nN'[v:searchforward]
onoremap <expr> N  'nN'[v:searchforward]

" center searches {{{2
nnoremap *  *zzzv
nnoremap #  #zzzv
nnoremap g* g*zzzv
nnoremap g# g#zzzv

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
inoremap <silent> <Bslash>o <C-x><C-o>
inoremap <silent> <Bslash>f <C-x><C-f>
inoremap <silent> <Bslash>i <C-x><C-i>
inoremap <silent> <Bslash>l <C-x><C-l>
inoremap <silent> <Bslash>n <C-x><C-n>
inoremap <silent> <Bslash>t <C-x><C-]>
inoremap <silent> <Bslash>u <C-x><C-u>
inoremap <silent> ,i <Cmd>Icons<CR>

" add chars to EOL {{{2
nnoremap <Bslash>, mzA,<Esc>;`z
nnoremap <Bslash>; mzA;<Esc>;`z

" unimpaired {{{2
" exchange lines
nnoremap ]e :execute 'move .+' . v:count1<CR>==
inoremap ]e <Esc>:m .+1<CR>==gi
vnoremap ]e :<C-u>execute "'<,'>move '>+" . v:count1<CR>gv=gv
nnoremap [e :execute 'move .-' . (v:count1 + 1)<CR>==
inoremap [e <Esc>:m .-2<CR>==gi
vnoremap [e :<C-u>execute "'<,'>move '<-" . (v:count1 + 1)<CR>gv=gv

" toggles
nmap yol :set list!<BAR>set list?<CR>
nmap yon :set number!<BAR>redraw!<BAR>set number?<CR>
nmap yos :set spell!<BAR>set wrap?<CR>
nmap yow :set wrap!<BAR>set wrap?<CR>
nmap yo~ :set autochdir!<BAR>set autochdir?<CR>

" insert special chars {{{2
inoremap \sec Section:
iabbrev n- –
iabbrev m- —
" }}}1

" Section: plugins {{{1

" let g:plug_home = stdpath('data') . '/site/pack/core/opt'
" ~/.local/share/nvim/site/pack/core/opt
call plug#begin()
Plug 'alker0/chezmoi.vim'
Plug 'dense-analysis/ale'
Plug 'github/copilot.vim'
Plug 'lervag/vimtex'
Plug 'AndrewRadev/dsf.vim'
Plug 'AndrewRadev/splitjoin.vim'
Plug 'tpope/vim-git'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-rsi'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-scriptease'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-tbone'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-capslock'
Plug 'tpope/vim-characterize'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-unimpaired'
Plug 'bullets-vim/bullets.vim'
Plug 'vuciv/golf'
" Plug '~/GitHub/rdnajac/vim-lol'

if !has('nvim')
  Plug 'Konfekt/FastFold'
  Plug 'junegunn/vim-easy-align'
  " Plug 'tpope/vim-sensible'
  Plug 'tpope/vim-vinegar'
  Plug 'tpope/vim-commentary' " TODO: try the shipped vim9 comment plugin
else
  Plug! 'folke/snacks.nvim'
endif
call plug#end()
" }}}1

" Section: commands {{{1
command! -nargs=1 Info  call vim#notify#info(<q-args>)
command! -nargs=1 Warn  call vim#notify#warn(<q-args>)
command! -nargs=1 Error call vim#notify#error(<q-args>)
" }}}

if !has('nvim')
  color scheme
else
  " call v:lua.require'snacks'.debug(g:plugins)
  " call v:lua.Snacks.debug(g:plugins)
endif

if !exists('g:vimrc_reload_count')
  let g:vimrc_reload_count = 0
else
  let g:vimrc_reload_count += 1
  let msg = 'Reloaded vimrc [' . g:vimrc_reload_count . ']'
  call vim#notify#info(msg)
endif
