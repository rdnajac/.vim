" $MYVIMRC
scriptencoding utf-8
color scheme
" Section: settings {{{1
setglobal isfname+=@-@ " from `vim-apathy`
" default: `@,48-57,/,.,-,_,+,,,#,$,%,~,=`
set wildignore+=.DS_Store
set wildignore+=*.o,*.out,*.a,*.so,*.viminfo

" general {{{2
set splitbelow splitright
" minimax wants `usetab`
set switchbuf+=vsplit
set splitkeep=screen
set timeoutlen=420
set updatetime=69

" navigation {{{ 2
set jumpoptions+=stack
set mouse=a
set scrolloff=8
set virtualedit=block
set whichwrap+=<,>,[,],h,l

" searching {{{ 2
set ignorecase
set smartcase

" notifications {{{ 2
set report=0
set shortmess+=aAcCI
set shortmess-=o
set showmatch

" appearance of chars {{{ 2
set fillchars= " reset
" set fillchars+=diff:╱
" set fillchars+=eob:,
" set fillchars+=stl:\ ,
set fillchars+=fold:\ ,
set fillchars+=foldclose:▸,
set fillchars+=foldopen:▾,
" set fillchars+=foldsep:\ ,

set list
set listchars= " reset
set listchars+=trail:¿,
set listchars+=tab:→\ ",
set listchars+=extends:…,
set listchars+=precedes:…,
set listchars+=nbsp:+

" fold {{{ 2
set foldlevel=99
" set foldlevelstart=1
" set foldminlines=3
set foldopen+=insert,jump
" set foldmethod=marker

" indent {{{2
" set nowrap TODO: set this in a ftplugin?
set breakindent
" TODO: from minimax; keep?
set breakindentopt=list:1
set linebreak
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
" set sessionoptions-=tabpages  " per project, not global
set sessionoptions-=terminal  " don't save terminals
set sessionoptions-=folds
set viewoptions-=options      " keep mkview minimal

" ui {{{2
let &laststatus = has('nvim') ? 3 : 2
set tabline=%!vimline#tabline#()
set cursorline
set number
set signcolumn=number
set termguicolors
" TODO: from minimax; keep?
" set cursorlineopt = 'screenline,number'
" -- Pattern for a start of numbered list (used in `gw`). This reads as
" -- "Start of list item is: at least one special character (digit, -, +, *)
" -- possibly followed by punctuation (. or `)`) followed by at least one space".
" vim.o.formatlistpat = [[^\s*[0-9\-\+\*]\+[\.\)]*\s\+]]

augroup vimrc_ui
  " no cursorline in insert mode
  au InsertLeave,WinEnter * if exists('w:had_cul') | setl cul | unlet w:had_cul | endif
  au InsertEnter,WinLeave * if &cul | let w:had_cul = 1 | setl nocul | endif

  " hide the statusline while in command mode
  au CmdlineEnter * if &ls != 0 | let g:last_ls = &ls | set ls=0 |endif
  au CmdlineLeave * if exists('g:last_ls') | let &ls = g:last_ls | unlet g:last_ls | endif

  " relative numbers in visual mode only if number is already set
  au ModeChanged [vV\x16]*:* if &nu| let &l:rnu = mode() =~# '^[vV\x16]' | endif
  au ModeChanged *:[vV\x16]* if &nu| let &l:rnu = mode() =~# '^[vV\x16]' | endif
  au WinEnter,WinLeave *     if &nu| let &l:rnu = mode() =~# '^[vV\x16]' | endif
augroup END

" }}}1
" Section: neovim {{{1
if !has('nvim')
  call vim#defaults#()
  call vim#sensible#()
  call vimrc#toggles()
else
  " set autocomplete
 
  " more navigation
  set smoothscroll
  set jumpoptions+=view
  set mousescroll=hor:0

  set pumblend=0
  set pumborder=rounded
  set pumheight=10
  set winborder=rounded

  set startofline " default in vim
  " run `:options` for more...

  " uncomment to disable the default popup menu
  " aunmenu PopUp | autocmd! nvim.popupmenu
endif

" }}}1
" Section: autocmds {{{1
augroup vimrc
  autocmd!
  au BufReadPost vimrc call vimrc#setmarks()
  au BufLeave vimrc normal! mV

  " create parent directories when saving files
  au BufWritePre * silent! call cmd#mkdir#(expand('<afile>'))

  " automatically reload certain config files when they are saved
  " au BufWritePost vimrc call reload#vimscript(expand('<afile>:p'))
  " au BufWritePost */ftplugin/* call reload#ftplugin(expand('<afile>:p'))

  " restore cursor position upon reopening files
  au BufWinEnter * exec "silent! normal! g`\"zv"

  " immediately quit the command line window if opened with `q`
  au CmdwinEnter * quit

  " automatically reload files that have been changed outside of Vim
  au FocusGained * if &buftype !=# 'nofile' | checktime | endif

  " automatically resize splits when the window is resized
  au VimResized * let g:tabpagenr = tabpagenr() | tabdo wincmd = | execute 'tabnext' g:tabpagenr

  au VimLeave * if v:dying | echo "\nAAAAaaaarrrggghhhh!!!\n" | endif

  au FileType json,jsonc,json5 setlocal conceallevel=0 et
  " close certain buffers with `q`
  au FileType help,qf,nvim-pack nnoremap <buffer> q :lclose<CR><C-W>q
  " don't list certain buffer types (see ...?)
  au FileType man,netrw,snacks_explorer setlocal nobuflisted
  " terminal stuff
  autocmd BufEnter term://*:R\ * startinsert
  autocmd BufEnter term://*/copilot startinsert

augroup END

" }}}1
" Section: commands/config {{{1
for level in keys(g:vim#notify#levels)
  execute printf('command! -nargs=1 -complete=expression %s call vim#notify#%s(eval(<q-args>))',
	\ toupper(strpart(level, 0, 1)) . strpart(level, 1), level)
endfor

command! -nargs=* Diff call cmd#diff#(<f-args>)
command! -nargs=0 Format call cmd#format#()
nnoremap zq <Cmd>Format<CR>

command! -nargs=1 -complete=customlist,cmd#scp#complete Scp call cmd#scp#(<f-args>)


let g:vimtex_format_enabled = 1              " built-in formatexpr
let g:vimtex_mappings_disable = {'n': ['K']} " disable normal `K`
let g:vimtex_quickfix_method = executable('pplatex') ? 'pplatex' : 'latexlog'
let g:eunuch_interpreters = {
      \ '.':      '/bin/sh',
      \ 'sh':     'bash',
      \ 'bash':   'bash',
      \ 'lua':    'nvim -l',
      \ 'python': 'python3',
      \ 'r':      'Rscript',
      \ 'rmd':    'Rscript',
      \ 'zsh':    'zsh',
      \ }
" }}}1
" Section: keymaps {{{1
let g:mapleader = ' '
let g:maplocalleader = '\'

nnoremap ; :
nnoremap ` ~
nnoremap ~ `

nnoremap  ciw
xnoremap  :sort<CR>

" requires `tpope/vim-unimpaired`
" nmap zJ ]ekJ
nnoremap zJ <Plug>(unimpaired-move-down)kJ

" TODO: diff?
" nnoremap dp     dp]c
" nnoremap do     do]c

" select last changed text (ie pasted text)
" TODO: doesn't gv already do this?
" see: *gv* *v_gv* *reselect-Visual*
nnoremap gV `[V`]

" `<leader>` {{{2
nnoremap <leader>- <Cmd>sbp<CR>
nnoremap <leader><Bar> <Cmd>vertical sbp<CR>
nnoremap <leader>K <Cmd>normal! K<CR>
nnoremap <leader>S <Cmd>Scriptnames<CR>
nnoremap <leader>Q :wqa!<CR>
nnoremap <leader>m <Cmd>messages<CR>
nnoremap <leader>q <Cmd>quit!<CR>
nnoremap <leader>w <Cmd>write!<CR>

if has('nvim')
  nnoremap <leader>h <Cmd>Help<CR>
  nnoremap <leader>r <Cmd>Restart<CR>
  nnoremap <leader>R <Cmd>restart!<CR>
else
  nnoremap <leader>h :<C-U>help<Space>
endif

" debug
nnoremap <leader>db <Cmd>verb se buftype? bufhidden? buflisted? filetype? syntax?<CR>
nnoremap <leader>df <Cmd>verb se foldenable? foldmethod? foldexpr? foldlevel? foldlevelstart? foldminlines?<CR>
nnoremap <leader>ds <Cmd>verb shell? shellcmdflag? shellpipe? shellquote? shellredir? shellslash? shellxquote?<CR>
if has('nvim')
  nnoremap <leader>dB <Cmd>Blink<CR>
  nnoremap <leader>dR <Cmd>=require('r.config').get_config()<CR>
  nnoremap <leader>dld <Cmd>LazyDev debug<CR>
  nnoremap <leader>dll <Cmd>LazyDev lsp<CR>
  nnoremap <leader>dlw <Cmd>=vim.lsp.buf.list_workspace_folders()<CR>
endif

" file
nnoremap <leader>fD <Cmd>Delete!<Bar>bwipeout #<CR>
nnoremap <leader>fR :set ft=<C-R>=&ft<CR><Bar>Info 'ft reloaded!'<CR>
nnoremap <leader>fS <Cmd>call edit#snippets()<CR>
nnoremap <leader>ft <Cmd>call edit#ftplugin()<CR>
nnoremap <leader>fT <Cmd>call edit#ftplugin('.lua')<CR>
nnoremap <leader>fw <Cmd>call format#clean_whitespace()<CR>

" navigation {{{2
nnoremap <BS> :bprevious<CR>
nnoremap <C-BS> g;
nnoremap <C-q> <Cmd>wincmd c<CR>

" `<C-e>` scrolls the window downwards by [count] lines
" `<C-^>` (`<C-6>`) which edits the alternate buffer `:e #`
nnoremap      <C-e>      <C-^>
nnoremap <C-w><C-e> <C-w><C-^>

for [dir, key] in items({'Left':'h', 'Down':'j', 'Up':'k', 'Right':'l'})
  execute $'nnoremap <S-{dir}> <Cmd>wincmd {key}<CR>'
  execute $'tnoremap <S-{dir}> <Cmd>wincmd {key}<CR>'
endfor

" see `:h sbp`
nnoremap <C-w><C-s> <Cmd>sbprevious<CR>
nnoremap <C-w><C-v> <Cmd>vertical +sbprevious<CR>
" TODO: S-Tab not detected?
" nnoremap <S-Tab>   <Cmd>wincmd w<CR>

" searching and centering {{{3
" make `n` and `N` behave the same way for `?` and `/` searches
" https://github.com/mhinz/vim-galore?tab=readme-ov-file#saner-behavior-of-n-and-n
" 'Nn'[v:searchforward] is the same as (v:searchforward ? 'n' : 'N')
" `zz` to center and since foldopen doesn work in mappings, add `zv`
nnoremap <expr> n (v:searchforward ? 'n' : 'N')..'zvzz'
nnoremap <expr> N (v:searchforward ? 'N' : 'n')..'zvzz'

" tabpages {{{3
nnoremap ]<Tab> <Cmd>tabnext<CR>
nnoremap [<Tab> <Cmd>tabprevious<CR>
nnoremap <leader><Tab><Tab> <Cmd>tabnew<CR>
nnoremap <leader><Tab>d <Cmd>tabclose<CR>
nnoremap <leader><Tab>D <Cmd>tabonly<CR>
nnoremap <leader><Tab>f :<C-U>tabfind<Space>

nnoremap <Bslash>i <Cmd>call edit#($MYVIMRC)<CR>
nnoremap <Bslash>n <Cmd>call edit#luamod('nvim')<CR>
nnoremap <leader><Bslash> <Cmd>call edit#readme()<CR>
nnoremap <Bslash><leader> <Cmd>call edit#readme()<CR>


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

" substitutions {{{2
" https://github.com/kaddkaka/vim_examples?tab=readme-ov-file#replace-only-within-selection
xnoremap s :s/\%V<C-R><C-W>/

" https://github.com/kaddkaka/vim_examples?tab=readme-ov-file#repeat-last-change-in-all-of-file-global-repeat-similar-to-g
nnoremap g. :%s//<C-r>./g<ESC>

" for act in ['c', 'd', 'y'] " change, delete, yank
"   for obj in ['w'] " paragraph, word
"     execute $'nnoremap {act}{obj} {act}i{obj}'
"     execute printf("nnoremap %s%s %si%s", act, toupper(obj), act, toupper(obj))
"   endfor
" endfor

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

" easier completion  {{{3
inoremap <silent> ,o <C-x><C-o>
" inoremap <silent> ,f <C-x><C-f>
" inoremap <silent> ,i <C-x><C-i>
" inoremap <silent> ,l <C-x><C-l>
" inoremap <silent> ,n <C-x><C-n>
" inoremap <silent> ,t <C-x><C-]>
" inoremap <silent> ,u <C-x><C-u>
inoremap <silent> ,i <Cmd>Icons<CR>

" terminal {{{2
tnoremap <expr> <C-R> '<C-\><C-N>"'.nr2char(getchar()).'pi'

" just like tmux!
" nnoremap <C-w>-     <C-w>s
" nnoremap <C-w><Bar> <C-w>v

" }}}1
" Section: pack {{{1
" packadd! vim-nv

" shipped plugins {{{2
packadd! cfilter
if has('nvim')
  packadd! nvim.difftool
  packadd! nvim.undotree
else
  packadd! editorconfig
  packadd! hlyank
endif
" }}}

call plug#begin()
Plug 'alker0/chezmoi.vim'
Plug 'dense-analysis/ale'
" Plug 'justinmk/vim-ug'
Plug 'lervag/vimtex'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-capslock'
Plug 'tpope/vim-characterize'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rsi'
Plug 'tpope/vim-scriptease'
Plug 'tpope/vim-unimpaired'
" Plug 'tpope/vim-dispatch'
" Plug 'tpope/vim-tbone'
" qol improvements and fun stuff
" Plug 'bullets-vim/bullets.vim'
" Plug 'dstein64/vim-startuptime'
" Plug 'vuciv/golf'
if !has('nvim')
  Plug 'andymass/vim-matchup'
  Plug 'github/copilot.vim'
  Plug 'junegunn/vim-easy-align'
  Plug 'justinmk/vim-dirvish'
  Plug 'romainl/vim-redir'
  " Plug 'tpope/vim-commentary' " use vim9 commentary
  " Plug 'tpope/vim-sensible'   " use vim#sensible#
  Plug 'tpope/vim-surround'
  Plug 'tpope/vim-repeat'
  " Plug 'tpope/vim-vinegar'    " use vim-dirvish
  Plug 'wellle/targets.vim'
  Plug 'wellle/tmux-complete.vim'
  Plug 'AndrewRadev/dsf.vim'
  Plug 'AndrewRadev/splitjoin.vim'
  Plug 'Konfekt/FastFold'
else
  Plug 'folke/snacks.nvim'
  Plug 'folke/tokyonight.nvim'
  Plug 'nvim-mini/mini.nvim'
  Plug 'chrisgrieser/nvim-scissors'
  " Plug 'j-hui/fidget.nvim'
  " Plug 'saxon1964/neovim-tips'
endif
Plug 'tpope/vim-dadbod'
Plug 'kristijanhusak/vim-dadbod-ui'
Plug 'kristijanhusak/vim-dadbod-completion'
call plug#end()
" }}}1
imap / /<C-x><C-f><C-n>
imap <expr> <Tab> pumvisible() ? <C-y> : <Tab>
" vim: fdm=marker fdl=1
