scriptencoding utf-8

function s:chsh(shell) abort
  let &shell = systemlist('which ' . a:shell)[0]
endfunction
" call s:chsh('dash')

" Section: settings {{{1
setglobal isfname+=@-@ " from `vim-apathy`
" default: `@,48-57,/,.,-,_,+,,,#,$,%,~,=`
set wildignore+=.DS_Store
set wildignore+=*.o,*.out,*.a,*.so,*.viminfo
set switchbuf+=vsplit

" general {{{2
set foldlevel=99
" set foldlevelstart=99
set foldminlines=3
set foldopen+=insert,jump
set foldtext=fold#text()
set foldmethod=marker
set ignorecase
set jumpoptions+=stack
set mouse=a
set report=0
set scrolloff=8
set shortmess+=aAcCI
set shortmess-=o
set showmatch
set smartcase
set splitbelow splitright
set splitkeep=screen
set timeoutlen=420
set updatetime=69
set virtualedit=block
set whichwrap+=<,>,[,],h,l

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
" set sessionoptions+=folds
" set sessionoptions-=options   " already default in nvim
set sessionoptions-=blank     " like vim-obsession
set sessionoptions-=tabpages  " per project, not global
set sessionoptions-=terminal  " don't save terminals
set sessionoptions-=folds
set viewoptions-=options      " keep mkview minimal

" ui {{{2
set cursorline
set termguicolors
let &laststatus = has('nvim') ? 3 : 2

" statuscolumn
" set foldcolumn=1
" set numberwidth=3
set number
set signcolumn=number

augroup vimrc_ui
  " no cursorline in insert mode
  au InsertLeave,WinEnter * if exists('w:had_cul') | setl cul | unlet w:had_cul | endif
  au InsertEnter,WinLeave * if &cul | let w:had_cul = 1 | setl nocul | endif

  " hide the statusline while in command mode
  au CmdlineEnter * if &ls != 0 | let g:last_ls = &ls | set ls=0 |endif
  au CmdlineLeave * if exists('g:last_ls') | let &ls = g:last_ls | unlet g:last_ls | endif

  " relative numbers in visual mode only if number is already set
  au ModeChanged [vV\x16]*:* if &l:nu| let &l:rnu = mode() =~# '^[vV\x16]' | endif
  au ModeChanged *:[vV\x16]* if &l:nu| let &l:rnu = mode() =~# '^[vV\x16]' | endif
  au WinEnter,WinLeave *     if &l:nu| let &l:rnu = mode() =~# '^[vV\x16]' | endif

  " au InsertEnter * let w:hlKeep = v:lua.Snacks.util.color('LspReferenceText', 'bg') | execute "lua Snacks.util.set_hl({ LspReferenceText = { link = 'NONE' } })"
  " au InsertLeave * lua vim.w.hlKeep and Snacks.util.set_hl({ LspReferenceText = { bg = vim.w.hlKeep } })

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
  au BufReadPost vimrc call vimrc#setmarks()
  au BufLeave vimrc normal! mV
  " au BufWritePost vimrc call reload#vimscript(expand('<afile>:p'))
  au BufWritePre * silent! call vim#mkdir#(expand('<afile>'))
  au BufWritePost */ftplugin/* call reload#ftplugin(expand('<afile>:p'))

  " restore cursor position
  au BufWinEnter * exec "silent! normal! g`\"zv"

  " immediately quit the command line window
  au CmdwinEnter * quit

  " automatically reload files that have been changed outside of Vim
  au FocusGained * if &buftype !=# 'nofile' | checktime | endif

  " automatically resize splits when the window is resized
  au VimResized * let t = tabpagenr() | tabdo wincmd = | execute 'tabnext' t | unlet t

  " terminal stuff
  autocmd BufEnter term://*:R\ * startinsert
  autocmd BufEnter term://*/copilot startinsert

  au VimLeave * if v:dying | echom "help im dying: " . v:dying | endif
augroup END

augroup vimrc_filetype
  autocmd!
  au FileType json,jsonc,json5 setlocal cole=0 et fex=v:lua.nv.json.format()
  au FileType help,qf,nvim-pack nnoremap <buffer> q :lclose<CR><C-W>q
  au FileType lua,json call vim#auto#braces()

  au FileType man,netrw,snacks_explorer setlocal nobuflisted
augroup END

" }}}1
" Section: commands {{{1
for level in keys(g:vim#notify#levels)
  execute printf('command! -nargs=1 -complete=expression %s call vim#notify#%s(eval(<q-args>))',
	\ toupper(strpart(level, 0, 1))..strpart(level, 1), level)
endfor

command! -nargs=* Diff call diff#wrap(<f-args>)
command! -nargs=0 Format call execute#inPlace('call format#buffer()')
command! -nargs=1 -complete=customlist,scp#complete Scp call scp#(<f-args>)

" }}}1
" Section: keymaps {{{1
nnoremap ; :
nnoremap ` ~
nnoremap ~ `

vmap  :sort<CR>

" diff?
" nnoremap dp     dp]c
" nnoremap do     do]c
" `<leader>` {{{2
let g:mapleader = ' '
let g:maplocalleader = '\'

" vim.lsp.hover overrides the default K mapping
nnoremap <leader>q :q!<CR>
nnoremap <leader>Q :wqa!<CR>
nnoremap <leader>- <Cmd>sbp<CR>
nnoremap <leader><Bar> <Cmd>vertical sbp<CR>
nnoremap <leader>K <Cmd>norm! K<CR>
nnoremap <leader>r <Cmd>Restart<CR>
nnoremap <leader>R <Cmd>restart!<CR>
nnoremap <leader>S <Cmd>Scriptnames<CR>
nnoremap <leader>m <Cmd>messages<CR>
nnoremap <leader>h <Cmd>Help<CR>
nnoremap <leader>w <Cmd>write!<CR>
nnoremap <leader>! <Cmd>call redir#prompt()<CR>

" debug
nnoremap <leader>db <Cmd>call debug#buffer()<CR>
nnoremap <leader>df <Cmd>call debug#fold()<CR>
nnoremap <leader>ds <Cmd>call debug#shell()<CR>

if has('nvim')
  nnoremap <leader>dB <Cmd>Blink<CR>
  nnoremap <leader>dld <Cmd>LazyDev debug<CR>
  nnoremap <leader>dll <Cmd>LazyDev lsp<CR>
  nnoremap <leader>dP <Cmd>=vim.tbl_keys(package.loaded)<CR>
  nnoremap <leader>dR <Cmd>=require("r.config").get_config()<CR>
  nnoremap <leader>dS <Cmd>=require("snacks").meta.get()<CR>
  nnoremap <leader>dw <Cmd>=vim.lsp.buf.list_workspace_folders()<CR>
endif

" file
nnoremap <leader>fD <Cmd>Delete!<Bar>bwipeout #<CR>
nnoremap <leader>fn <Cmd>call file#title()<CR>
nnoremap <leader>fR :set ft=<C-R>=&ft<CR><Bar>Info 'ft reloaded!'<CR>
nnoremap <leader>fs <Cmd>call edit#snippet()<CR>
nnoremap <leader>ft <Cmd>call edit#filetype()<CR>
nnoremap <leader>fw <Cmd>call format#clean_whitespace()<CR>

" git
nnoremap <leader>ga <Cmd>!git add %<CR>
nnoremap <leader>gN <Cmd>execute '!open' git#url('neovim/neovim')<CR>
nnoremap <leader>gZ <Cmd>execute '!open' git#url('lazyvim/lazyvim')<CR>

" navigate buffers, windows, and tabs {{{2
nnoremap <BS> :bprevious<CR>
nnoremap <C-BS> g;

" wincmds {{{3
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

" searching and centering {{{3
" make `n` and `N` behave the same way for `?` and `/` searches
" https://github.com/mhinz/vim-galore?tab=readme-ov-file#saner-behavior-of-n-and-n
" 'Nn'[v:searchforward] is the same as (v:searchforward ? 'n' : 'N')
" `zz` to center and since foldopen doesn work in mappings, add `zv`
nnoremap <expr> n (v:searchforward ? "n" : "N")."zvzz"
nnoremap <expr> N (v:searchforward ? "N" : "n")."zvzz"

" bookmarks {{{3
nnoremap <Bslash>0  <Cmd>call edit#readme()<CR>
nnoremap <Bslash>i  <Cmd>call edit#(expand('$MYVIMRC'))<CR>
nnoremap <Bslash>v  <Cmd>call edit#vimrc()<CR>

" resize splits {{{3
nnoremap <C-W><Up>    :     resize +10<CR>
nnoremap <C-W><Down>  :     resize -10<CR>
nnoremap <C-W><Left>  :vert resize +10<CR>
nnoremap <C-W><Right> :vert resize -10<CR>

" tabpages {{{3
nnoremap <leader><Tab>l <Cmd>tablast<CR>
nnoremap <leader><Tab>o <Cmd>tabonly<CR>
nnoremap <leader><Tab>f <Cmd>tabfirst<CR>
nnoremap <leader><Tab><Tab> <Cmd>tabnew<CR>
nnoremap <leader><Tab>d <Cmd>tabclose<CR>
nnoremap <leader><Tab>] <Cmd>tabnext<CR>
nnoremap <leader><Tab>[ <Cmd>tabprevious<CR>

" key pairs in normal mode {{{2
" `https://gist.github.com/romainl/1f93db9dc976ba851bbb`
" `cd` cm co cp `cq` `cr` `cs` cu cx cy cz
" `dc` dm dq dr `ds` du dx `dy` dz
" `gb` `gc` `gl` `gs` `gy`
" vm vo vq `vv` vz
" `yc` yd ym `yo` `yp` yq `yr` `ys` `yu` yx yz
" `zq` ZA ... ZP, `ZQ` ... `ZX` `ZZ`

nnoremap <expr> cq change#quote()

" delete/yank comment
nmap dc dgc
nmap yc ygc

nnoremap gb vi'"zy:!open https://github.com/<C-R>z<CR>
xnoremap gb    "zy:!open https://github.com/<C-R>z<CR>

" `fugitive`
nnoremap gcd :Gcd<Bar>pwd<CR>

" open file in a new window when or jump to line number when appropriate
nnoremap <expr> gf &ft =~# '\vmsg\|pager' ? ''
      \ : expand('<cWORD>') =~# ':\d\+$' ? 'gF' : 'gf'

" select last changed text (ie pasted text)
" TODO: does gv already do this?
nnoremap gV `[V`]

nnoremap zq <Cmd>Format<CR>
nnoremap ZX <Cmd>Zoxide<CR>

" resursive keymaps
nmap gy "xyygcc"xp<Up>
nmap gY "xyygcc"xP
nmap vv Vgc

" bracket mappings
nnoremap [o <C-o>
nnoremap ]o <C-i>

" assumes `unimpaired` exchange
nmap zJ ]ekJ

" `surround`
nmap S viWS
vmap ` S`
vmap F Sf

" qol {{{2
" change/delete current word {{{3
nnoremap c*   *``cgn
nnoremap c#   *``cgN
nnoremap cg* g*``cgn
nnoremap cg# g*``cgN
nnoremap d*   *``dgn
nnoremap d#   *``dgN
nnoremap dg* g*``dgn
nnoremap dg# g*``dgN

" better indenting {{{3
vnoremap < <gv
vnoremap > >gv
nnoremap > V`]>
nnoremap < V`]<

" substitutions {{{3
" https://github.com/kaddkaka/vim_examples?tab=readme-ov-file#replace-only-within-selection
xnoremap s :s/\%V<C-R><C-W>/

" https://github.com/kaddkaka/vim_examples?tab=readme-ov-file#repeat-last-change-in-all-of-file-global-repeat-similar-to-g
nnoremap g. :%s//<C-r>./g<ESC>

" folding {{{3
" better search if auto pausing folds
" set foldopen-=search
" nnoremap <silent> / zn/

nnoremap          zv zMzvzz
nnoremap <silent> zj zcjzOzz
nnoremap <silent> zk zckzOzz
" close folds when moving left at beginning of line
" TODO: make it wrap like whichwrap+=h or (col('.') == 1 ? 'gk$' : 'h')
nnoremap <expr> h virtcol('.') <= indent('.') + 1 ? 'zc' : 'h'

" save, override, and restore commentstring to get nice folds
xnoremap zf :<C-u>let s=&l:cms \| let &l:cms=' '.s \| '<,'>fold \| let &l:cms=s<CR>

" you know what I mean... {{{3
" for act in ['c', 'd', 'y'] " change, delete, yank
"   for obj in ['w'] " paragraph, word
"     execute $'nnoremap {act}{obj} {act}i{obj}'
"     execute printf("nnoremap %s%s %si%s", act, toupper(obj), act, toupper(obj))
"   endfor
" endfor

" don't capture whitespace in `gc`
nmap gcap gcip

" command definitions are more robust than abbreviations
command! W w!
command! Wq wq!
command! Wqa wqa!
" insert {{{2
" insert chars at EOL {{{3
nnoremap <Bslash>, mzA,<Esc>;`z
nnoremap <Bslash>; mzA;<Esc>;`z
nnoremap <Bslash>. mzA.<Esc>;`z

" insert special chars {{{3
" inoremap \sec Section:
iabbrev n- –
iabbrev m- —

" insert mode undo breakpoints {{{3
inoremap , ,<C-g>u
inoremap . .<C-g>u
inoremap ; ;<C-g>u

" insert comments {{{3
let s:comment_map = {
      \ 'o': '',
      \ 'b': 'BUG: ',
      \ 'f': 'FIXME: ',
      \ 'h': 'HACK: ',
      \ 'n': 'NOTE: ',
      \ 'p': 'PERF: ',
      \ 't': 'TODO: ',
      \ 'x': 'XXX: ',
      \ 'i': 'stylua: ignore',
      \ }

" map `co` and `cO` to insert comments with specific tags
for [key, val] in items(s:comment_map)
  execute printf('nmap co%s :call comment#below("%s")<CR>', key, val)
  execute printf('nmap cO%s :call comment#above("%s")<CR>', key, val)
  execute printf('nmap co%s :call comment#above("%s")<CR>', toupper(key), val)
endfor

" easier completion  {{{3
inoremap <silent> ,o <C-x><C-o>
" inoremap <silent> ,f <C-x><C-f>
" inoremap <silent> ,i <C-x><C-i>
" inoremap <silent> ,l <C-x><C-l>
" inoremap <silent> ,n <C-x><C-n>
" inoremap <silent> ,t <C-x><C-]>
" inoremap <silent> ,u <C-x><C-u>
inoremap <silent> ,i <Cmd>Icons<CR>
" cmdline {{{2
" completion {{{3
" see `:h |cmdline-completion|.`
set completeopt=menu,preview,longest
" set completeopt+=preinsert

" More info here: |cmdline-completion|; default: `wildmode=full`
" set wildmode=longest,full    " 1 First press: longest common substring, Second press: full match
set wildmode=longest:full,full " Same as above, but cycle through the first patch ('preinsert'?)
" set wildmode=longest,list    " First press: longest common substring, Second press: list all matches
" set wildmode=noselect:full   " Show 'wildmenu' without selecting, then cycle full matches
" set wildmode=noselect:lastused,full " Same as above, but buffer matches are sorted by time last used

" Up and Down arrow keys to navigate completion menu
cnoremap <expr> <Down> wildmenumode() ? "\<C-n>" : "\<Down>"
cnoremap <expr> <Up> wildmenumode() ? "\<C-p>" : "\<Up>"

" abbreviations {{{3
nnoremap ?? :verbose set ?<Left>
cnoreabbrev ?? verbose set ?<Left>
cnoreabbrev !! !./%
cnoreabbrev <expr> %% expand('%:p:h')

function! s:singlequote(str)
  return "'" . substitute(copy(a:str), "'", "''", 'g') . "'"
endfunction

function! s:cabbrev(lhs, rhs)
  " execute printf( 'cnoreabbrev <expr> %s (getcmdtype() ==# ":" && getcmdline() =~# "%s") ? "%s" : "%s"',
  execute printf('cabbrev <expr> %s (getcmdtype() == ":" && getcmdpos() <= %d) ? %s : %s',
	\ a:lhs, 1+len(a:lhs), s:singlequote(a:rhs), s:singlequote(a:lhs))
endfunction

call s:cabbrev('vv', 'verbose')
call s:cabbrev('scp', '!scp %')
call s:cabbrev('require', 'lua require')
call s:cabbrev('man', 'Man')
call s:cabbrev('Snacks', 'lua Snacks')
call s:cabbrev('snacks', 'lua Snacks')
call s:cabbrev('f', 'find')
" }}}1

if has('nvim')
  packadd! nvim.difftool
  packadd! nvim.undotree
else
  packadd! editorconfig
  packadd! hlyank
  packadd vim-jetpack
endif
packadd! cfilter

call plug#begin()
Plug 'alker0/chezmoi.vim'
Plug 'bullets-vim/bullets.vim'
Plug 'dense-analysis/ale'
Plug 'justinmk/vim-dirvish'
Plug 'justinmk/vim-ug'
Plug 'lervag/vimtex'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-capslock'
Plug 'tpope/vim-characterize'
Plug 'tpope/vim-dadbod'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rsi'
Plug 'tpope/vim-scriptease'
Plug 'tpope/vim-unimpaired'
if !has('nvim')
  Plug 'andymass/vim-matchup'
  Plug 'dstein64/vim-startuptime'
  Plug 'github/copilot.vim'
  Plug 'junegunn/vim-easy-align'
  Plug 'romainl/vim-redir'
  " Plug 'tpope/vim-commentary' " use vim9 commentary
  Plug 'tpope/vim-repeat'
  " Plug 'tpope/vim-sensible'
  Plug 'tpope/vim-surround'
  Plug 'tpope/vim-tbone'
  " Plug 'tpope/vim-vinegar'    " use dirvish
  Plug 'wellle/targets.vim'
  Plug 'wellle/tmux-complete.vim'
  Plug 'AndrewRadev/dsf.vim'
  Plug 'AndrewRadev/splitjoin.vim'
  Plug 'Konfekt/FastFold'
  Plug 'vuciv/golf'
else
  " Plug 'folke/tokyonight.nvim'
  " Plug 'folke/snacks.nvim'
  Plug 'saxon1964/neovim-tips'
endif
call plug#end() " don't plug#end() if neovim...
"packadd! vim-lol
"call lol#cat()
" vim: foldlevel=0 foldmethod=marker
