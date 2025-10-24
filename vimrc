scriptencoding utf-8
let g:mapleader = ' '
let g:maplocalleader = '\'
execute 'call vimrc#init_' . (has('nvim') ? 'n' : '') . 'vim()'
" TODO: find thecode for automatic marks
call vimrc#autosection()
" Section: settings {{{1

" general
set jumpoptions+=stack
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
set virtualedit=block
set whichwrap+=<,>,[,],h,l

" searching
set ignorecase
set showmatch
set smartcase

" text
set breakindent
set linebreak
set nowrap
set shiftround
" don't change tabstop! use `sw` and `sts`
set shiftwidth=2
set softtabstop=2

augroup vimrc_indent
  autocmd!
  " autocmd FileType markdown,tex    setl sw=2 sts=2
  autocmd FileType cpp,cuda,python setl sw=4 sts=4
  autocmd FileType c,sh,zsh        setl sw=8 sts=8
augroup END

" ui
set lazyredraw
set termguicolors
set fillchars= " reset
set fillchars+=diff:╱
set fillchars+=eob:,
set fillchars+=stl:\ ,
set list
set listchars= " reset
set listchars+=trail:¿,
set listchars+=tab:→\ ",
set listchars+=extends:…,
set listchars+=precedes:…,
set listchars+=nbsp:+

" sesh
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
  au BufWritePre * call vim#mkdir#(expand('<afile>'))
  au BufWritePost vimrc call reload#vimscript(expand('<afile>:p'))
  au BufWritePost */ftplugin/* call reload#ftplugin(expand('<afile>:p'))

  " restore cursor position
  au BufWinEnter * exec "silent! normal! g`\"zv"

  " immediately quit the command line window
  au CmdwinEnter * quit

  " automatically reload files that have been changed outside of Vim
  au FocusGained * if &buftype !=# 'nofile' | checktime | endif

  " automatically resize splits when the window is resized
  au VimResized * let t = tabpagenr() | tabdo wincmd = | execute 'tabnext' t | unlet t

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
  au FileType json,jsonc,json5 setlocal cole=0 et fex=v:lua.nv.json.format()
  au FileType help,qf,nvim-pack nnoremap <buffer> q :lclose<CR><C-W>q
  au FileType lua,json call vim#auto#braces()

  au FileType man setlocal nobuflisted
augroup END

" Section: keymaps {{{1

" quit stuff
nnoremap <C-q> <Cmd>wincmd c<CR>
nnoremap <leader>q :q!<CR>

" make it easier to toggle letter case
nnoremap ` ~
" use `'` to go to mark instead
nnoremap ~ `

" <C-c> is a dangerous key to use frequently
" nmap  ciw
" stop using <BS> for buffer navigation...
nmap <BS> ciw

" you know what I mean...
nmap gcap gcip

" TODO: substitute: TODO...
" https://github.com/kaddkaka/vim_examples?tab=readme-ov-file#replace-only-within-selection
xnoremap s :s/\%V<C-R><C-W>/

" https://github.com/kaddkaka/vim_examples?tab=readme-ov-file#repeat-last-change-in-all-of-file-global-repeat-similar-to-g
nnoremap g. :%s//<c-r>./g<esc>

" " a global function with a distinct name
" function! BufSubstituteAll(find, replace) abort
"   " escape any slash or backslash in the arguments
"   let l:find    = escape(a:find,    '/\')
"   let l:replace = escape(a:replace, '/\')
"   " run the substitute in every buffer, then write if changed
"   execute 'bufdo %s/\V' . l:find . '/' . l:replace . '/g | update'
" endfunction
"
" " the user‐facing command calls that function
" command! -nargs=2 Sall call BufSubstituteAll(<f-args>)

" bookmarks {{{2
nnoremap <Bslash>0  <Cmd>call edit#readme()<CR>
nnoremap <Bslash>i  <Cmd>call edit#(expand('$MYVIMRC'))<CR>
nnoremap <leader>vv <Cmd>call edit#vimrc()<CR>

nnoremap <leader>ft <Cmd>call edit#filetype()<CR>
nnoremap <leader>fT <Cmd>call edit#filetype('.lua')<CR>
nnoremap <leader>fs <Cmd>call edit#filetype('snippets/', '.json')<CR>

vmap  :sort<CR>

" just like tmux!
" nnoremap <C-w>-     <C-w>s
" nnoremap <C-w><Bar> <C-w>v

" key pairs in normal mode
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

nnoremap <expr> gf keymap#g#f()

" `fugitive`
nnoremap gcd :Gcd<Bar>pwd<CR>

nnoremap zq <Cmd>Format<CR>

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

" vim.lsp.hover overrides the default K mapping
nnoremap <leader>K <Cmd>norm! K<CR>
nnoremap <leader>r <Cmd>call sesh#restart()<CR>
nnoremap <leader>R <Cmd>restart!<CR>
nnoremap <leader>S <Cmd>Scriptnames<CR>
nnoremap <leader>m <Cmd>messages<CR>
nnoremap <leader>N <Cmd>lua Snacks.picker.notifications()<CR>
" nnoremap <leader>N <Cmd>lua Snacks.notifier.show_history()<CR>
" nnoremap <leader>ff <Cmd>lua Snacks.picker.files()<CR>
nnoremap <leader>h <Cmd>Help<CR>
nnoremap <leader>w <Cmd>write!<CR>
nnoremap <leader>! <Cmd>call redir#prompt()<CR>

nnoremap <leader>fD <Cmd>Delete!<Bar>bwipeout #<CR>
nnoremap <leader>fR :set ft=<C-R>=&ft<CR><Bar>Info 'ft reloaded!'<CR>
nnoremap <leader>fn <Cmd>call file#title()<CR>
nnoremap <leader>fw <Cmd>call format#clean_whitespace()<CR>

" git
nnoremap <leader>ga <Cmd>!git add %<CR>
nnoremap <leader>gN <Cmd>execute '!open' git#url('neovim/neovim')<CR>
nnoremap <leader>gZ <Cmd>execute '!open' git#url('lazyvim/lazyvim')<CR>

nnoremap  <leader><Tab> <Cmd>e #<CR>

" resize splits
nnoremap <C-W><Up>    :         resize +10<CR>
nnoremap <C-W><Down>  :         resize -10<CR>
nnoremap <C-W><Left>  :vertical resize +10<CR>
nnoremap <C-W><Right> :vertical resize -10<CR>

" smarter j/k
" handle wrapped lines better by preferring `gj` and `gk`
let s:keys = [ 'j', 'k' , '<Down>', '<Up>']
for [i, key] in items(s:keys)
  let dir = s:keys[i % 2] " limit dir to only j/k
  execute printf("nnoremap <expr> %s v:count ? '%s' : 'g%s'", key, dir, dir)
  execute printf("xnoremap <expr> %s v:count ? '%s' : 'g%s'", key, dir, dir)
endfor
unlet s:keys

" better n/N
" https://github.com/mhinz/vim-galore?tab=readme-ov-file#saner-behavior-of-n-and-n
nmap n nzz
" nnoremap <expr> n  'Nn'[v:searchforward]
xnoremap <expr> n  'Nn'[v:searchforward]
onoremap <expr> n  'Nn'[v:searchforward]

nmap N Nzz
" nnoremap <expr> N  'nN'[v:searchforward]
xnoremap <expr> N  'nN'[v:searchforward]
onoremap <expr> N  'nN'[v:searchforward]

" center searches
nnoremap *  *zzzv
nnoremap #  #zzzv
nnoremap g* g*zzzv
nnoremap g# g#zzzv

" lervag/dotfiles
" already in nivm
" nnoremap Y      y$
" nnoremap '      `

" TODO:
nnoremap J      mzJ`z
nnoremap dp     dp]c
nnoremap do     do]c

nnoremap gV     `[V`]

" Buffer navigation
" nnoremap <silent> gb    :bnext<cr>
" nnoremap <silent> gB    :bprevious<cr>

" `<C-e>` scrolls the window downwards by [count] lines;
" `<C-^>` (`<C-6>`) which edits the alternate  buffer`:e #`
nnoremap <C-e>            <C-^>
nnoremap <C-w><C-e>  <C-w><C-^>

" Utility maps for repeatable quickly change/delete current word
nnoremap c*   *``cgn
nnoremap c#   *``cgN
nnoremap cg* g*``cgn
nnoremap cg# g*``cgN
nnoremap d*   *``dgn
nnoremap d#   *``dgN
nnoremap dg* g*``dgn
nnoremap dg# g*``dgN

" better indenting
vnoremap < <gv
vnoremap > >gv
nnoremap > V`]>
nnoremap < V`]<

" insert mode undo breakpoints
inoremap , ,<C-g>u
inoremap . .<C-g>u
inoremap ; ;<C-g>u

" easier completion
inoremap <silent> ,o <C-x><C-o>
" inoremap <silent> ,f <C-x><C-f>
" inoremap <silent> ,i <C-x><C-i>
" inoremap <silent> ,l <C-x><C-l>
" inoremap <silent> ,n <C-x><C-n>
" inoremap <silent> ,t <C-x><C-]>
" inoremap <silent> ,u <C-x><C-u>
inoremap <silent> ,i <Cmd>Icons<CR>

" add chars to EOL
nnoremap <Bslash>, mzA,<Esc>;`z
nnoremap <Bslash>; mzA;<Esc>;`z

" unimpaired
" exchange lines
nnoremap ]e :execute 'move .+' . v:count1<CR>==
" inoremap ]e <Esc>:m .+1<CR>==gi
vnoremap ]e :<C-u>execute "'<,'>move '>+" . v:count1<CR>gv=gv
nnoremap [e :execute 'move .-' . (v:count1 + 1)<CR>==
" inoremap [e <Esc>:m .-2<CR>==gi
vnoremap [e :<C-u>execute "'<,'>move '<-" . (v:count1 + 1)<CR>gv=gv

" insert special chars
inoremap \sec Section:
iabbrev n- –
iabbrev m- —


" Section: commands {{{1
command! -nargs=1 Info call vim#notify#info(eval(<q-args>))
command! -nargs=1 Warn call vim#notify#warn(eval(<q-args>))
command! -nargs=1 Error call vim#notify#error(eval(<q-args>))

command! -nargs=1 -complete=customlist,scp#complete Scp call scp#(<f-args>)

" }}}1
" Section: ui {{{1
let &laststatus = has('nvim') ? 3 : 2
set statusline=%!vimline#statusline#()

" set foldcolumn=1
" set signcolumn=number
set signcolumn=auto
" set numberwidth=3

" }}}1
" Section: plugins  {{{1
call plug#begin()
Plug 'alker0/chezmoi.vim'
" Plug 'andymass/vim-matchup'
" Plug 'bullets-vim/bullets.vim'
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
" Plug 'tpope/vim-rsi'
" forks
" Plug 'tpope/vim-tbone'
" Plug 'tpope/vim-vinegar'
" Plug 'tpope/vim-sensible'
" Plug 'tpope/vim-scriptease'
if !has('nvim')
  Plug 'dense-analysis/ale'
  Plug 'dstein64/vim-startuptime'
  Plug 'github/copilot.vim'
  Plug 'junegunn/vim-easy-align'
  Plug 'tpope/vim-unimpaired'
  Plug 'wellle/targets.vim'
  Plug 'wellle/tmux-complete.vim'
  Plug 'tpope/vim-repeat'
  Plug 'tpope/vim-surround'
  " Plug 'tpope/vim-commentary'
  Plug 'AndrewRadev/dsf.vim'
  Plug 'AndrewRadev/splitjoin.vim'
  Plug 'Konfekt/FastFold'
  Plug 'vuciv/golf'
else
  Plug 'saxon1964/neovim-tips'
endif
call plug#end()
" vim: foldlevelstart=1 foldmethod=marker
