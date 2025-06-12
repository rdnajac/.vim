" vimrc
scriptencoding=utf-8

let g:mapleader = ' '
let g:maplocalleader = '\'

" § settings {{{2
let s:VIMHOME = expand('$HOME/.config/vim//')
let g:plug_home = s:VIMHOME . './plugged//'
let &spellfile = s:VIMHOME . '.spell/en.utf-8.add'

if !has('nvim')
  let &undodir     = s:VIMHOME . '.undo//'
  let &viminfofile = s:VIMHOME . '.viminfo'
  " let &verbosefile = s:VIMHOME . '.vimlog.txt'

  " better escape
  noremap jk <esc>
  noremap kj <esc>

  silent! color scheme

  if system('uname') =~? '^darwin'
    set clipboard=unnamed
  else
    set clipboard=unnamedplus
  endif
endif

" options {{{
" set backup
set undofile undolevels=10000
set autowrite
set breakindent
" set confirm
set cursorline
set fillchars+=diff:╱,
set fillchars+=eob:\ ,
set fillchars+=fold:\ ,
set fillchars+=foldclose:▸,
set fillchars+=foldopen:▾,
set fillchars+=foldsep:\ ,
set fillchars+=foldsep:│
set fillchars+=stl:\ ,
set formatoptions-=or
set foldmethod=marker
set foldopen+=insert,jump
set ignorecase smartcase
set linebreak
set list
set listchars=trail:¿,tab:→\ "
set mouse=a
set nowrap
set noruler
" set laststatus=0
" set number
set numberwidth=3
set pumheight=10
set report=0
set scrolloff=8
set shiftround
set shortmess+=aAcCI
set shortmess-=o
set showmatch
set splitbelow splitright
set splitkeep=screen
set termguicolors
set timeoutlen=420
set updatetime=69
set whichwrap+=<,>,[,],h,l
set signcolumn=yes

set completeopt=menu,preview,preinsert,longest
" set completeopt=menu,preview,longest
set wildmode=longest:full,full
" }}}2

" § autocmds {{{1
augroup vimrc " {{{2
  autocmd!
  au BufReadPost $MYVIMRC call vim#vimrcmarks()
  au CmdwinEnter * quit
  au BufWritePre * call bin#mkdir#mkdir(expand('<afile>'))
  " au BufDelete * if winnr('$') == 1 && &filetype ==# 'snacks_terminal' | execute 'qa!' | endif
  " au BufDelete * if len(filter(getbufinfo(), 'v:val.listed')) == 0 | execute 'qa!' | endif
  au BufWritePost $MYVIMRC source $MYVIMRC | echom 'vimrc reloaded'
augroup END

augroup FileTypeSettings " {{{2
  au!
  au FileType sh,zsh           setl sw=8 sts=8 noet wrap nonu
  au FileType c                setl sw=8 sts=8 noet
  au FileType cpp,cuda         setl sw=4 sts=4
  au FileType toml,yaml        setl sw=2 sts=2
  au FileType python           setl sw=4 sts=4
  au FileType r,rmd,quarto     setl sw=2 sts=2 kp=:Rhelp
  au FileType vim,lua          setl sw=2 sts=2 kp=:help  nonu
  au FileType tex              setl            fdm=syntax
  au FileType json,jsonc,json5 setl sw=2 sts=2 conceallevel=0
augroup END

augroup ConfigFileSettings " {{{2
  autocmd!
  autocmd FileType tmux,sshconfig,mason setlocal iskeyword+=- | nnoremap <buffer> <C-Space> viW
augroup END

augroup RestoreCursorOpenFold " {{{2
  autocmd!
  autocmd BufWinEnter * let line = line("'\"") |
	\ if line >= 1 && line <= line("$") |
	\   execute "silent! normal! g`\"zO" |
	\ endif
augroup END

augroup AutoReloadFile " {{{2
  autocmd!
  autocmd FocusGained * if &buftype !=# 'nofile' | checktime | endif
  if has('nvim')
    autocmd TermClose,TermLeave * if &buftype !=# 'nofile' | checktime | endif
  endif
augroup END

augroup ResizeSplits " {{{2
  autocmd!
  autocmd VimResized * let t = tabpagenr() | tabdo wincmd = | execute 'tabnext' t
augroup END

augroup SetLocalPath " {{{2
  autocmd!
  let s:default_path = escape(&path, '\ ') " store default value of 'path'

  " Always add the current file's directory to the path and tags list if not
  " already there. Add it to the beginning to speed up searches.
  autocmd BufRead *
	\ let s:tempPath = escape(escape(expand("%:p:h"), ' '), '\ ') |
	\ exec "set path-=" . s:tempPath |
	\ exec "set path-=" . s:default_path |
	\ exec "set path^=" . s:tempPath |
	\ exec "set path^=" . s:default_path
augroup END
" }}}2

" § commands {{{1
command! -bar -bang -nargs=+ Chmod execute bin#chmod#chmod(<bang>0, <f-args>)
command! -bar -bang          Delete call bin#delete#delete(<bang>0)

command! -nargs=1 -complete=customlist,bin#scp#complete Scp call bin#scp#scp(<f-args>)

" current file
command! CDC cd %:p:h <BAR> pwd
" parent directory
command! CDP cd %:p:h:h

command! BreakHere call utils#breakHere()
command! ReplaceSelection call utils#replaceSelection()
command! CleanWhitespace call format#whitespace()
nmap <leader>fw <cmd>CleanWhitespace<CR>

nnoremap <space>j <Cmd>BreakHere<CR>
vnoremap <C-r> <cmd>ReplaceSelection<CR>

nnoremap Q <Cmd>call format#buffer()<CR>

command! -range SendVisual <line1>,<line2>call ooze#sendvisual()

if has('nvim')
  command! LazyHealth Lazy! load all | checkhealth
  command! Chezmoi     :lua require('munchies.picker').chezmoi()
  command! Plugins     :lua require('munchies.picker').plugins()
  command! Scriptnames :lua require('munchies.picker').scriptnames()

  " TODO: vim.api.nvim_create_autocmd('CmdlineEnter', {
  cnoreabbrev <expr> Snacks getcmdtype() == ':' && getcmdline() =~ '^Snacks' ? 'lua Snacks' : 'Snacks'
  cnoreabbrev <expr> snacks getcmdtype() == ':' && getcmdline() =~ '^snacks' ? 'lua Snacks' : 'snacks'
  cnoreabbrev <expr> require getcmdtype() == ':' && getcmdline() =~ '^require' ? 'lua require' : 'require'
endif

cnoreabbrev <expr> man (getcmdtype() ==# ':' && getcmdline() =~# '^man\s*$') ? 'Man' : 'man'

" § keymaps {{{1
nnoremap <BS> <C-o>
nnoremap <leader><BS> <C-t>
nnoremap ` ~

nmap <C-c> ciw
vmap <C-s> :sort<CR>

nnoremap <leader>K <Cmd>norm! K<CR>
nnoremap <leader>Q <Cmd>qa<CR>

nnoremap <leader>a :normal! ggVG<CR>
nnoremap <leader>m <Cmd>messages<CR>
" nnoremap <leader>r <Cmd>source $MYVIMRC <Bar> echom 'Reloaded config!'<CR>
" nnoremap <leader>r <Cmd>Restart<CR>
nnoremap <leader>v <Cmd>edit $MYVIMRC<CR>
nnoremap <leader>E <Cmd>edit<CR>
nnoremap <leader>w <Cmd>write<CR>
nnoremap <leader>t <Cmd>edit #<CR>
nnoremap <leader>i :help index<CR>

function! s:edit(relpath, ext)
  let suffix = empty(&filetype) ? '' : &filetype . a:ext
  execute 'edit ' . fnamemodify($MYVIMRC, ':p:h') . '/' . a:relpath . suffix
endfunction

nnoremap <leader>ft :call <SID>edit('after/ftplugin/', '.vim')<CR>
nnoremap <leader>fT :call <SID>edit('lua/config/lazy/lang/', '.lua')<CR>
nnoremap <leader>fs :call <SID>edit('snippets/', '.json')<CR>
nnoremap <leader>fD <Cmd>Delete!<CR>

" buffers {{{
nnoremap <silent> <Tab>         :bnext<CR>
nnoremap <silent> <S-Tab>       :bprev<CR>
nnoremap <silent> <leader><Tab> :e #<CR>
nnoremap <silent> <leader>bD    :bd<CR>

" Close buffer
map <silent> <C-q> <Cmd>bd<CR>
" }}}
" resize splits {{{
" nnoremap <M-Up>    :resize -2<CR>
" nnoremap <M-Down>  :resize +2<CR>
nnoremap <M-Left>  :vertical resize -2<CR>
nnoremap <M-Right> :vertical resize +2<CR>
" }}}
" smarter j/k {{{
nnoremap <expr> j      v:count == 0 ? 'gj' : 'j'
xnoremap <expr> j      v:count == 0 ? 'gj' : 'j'
nnoremap <expr> k      v:count == 0 ? 'gk' : 'k'
xnoremap <expr> k      v:count == 0 ? 'gk' : 'k'
nnoremap <expr> <Down> v:count == 0 ? 'gj' : 'j'
xnoremap <expr> <Down> v:count == 0 ? 'gj' : 'j'
nnoremap <expr> <Up>   v:count == 0 ? 'gk' : 'k'
xnoremap <expr> <Up>   v:count == 0 ? 'gk' : 'k'
" }}}
" https://github.com/mhinz/vim-galore?tab=readme-ov-file#saner-behavior-of-n-and-n {{{
" normal mode also openz folds and centers the cursor
nnoremap <expr> n ('Nn'[v:searchforward]) . 'zvzz'
xnoremap <expr> n  'Nn'[v:searchforward]
onoremap <expr> n  'Nn'[v:searchforward]

nnoremap <expr> N ('nN'[v:searchforward]) . 'zvzz'
xnoremap <expr> N  'nN'[v:searchforward]
onoremap <expr> N  'nN'[v:searchforward]

nnoremap *  *zzzv
nnoremap #  #zzzv
nnoremap g* g*zzzv
nnoremap g# g#zzzv

" comments {{{
" comment-out and duplicate line
nmap yc "xyygcc"xp

" toggle visual selection
vmap ~ gc

" better indenting {{{
vnoremap < <gv
vnoremap > >gv
nnoremap > V`]>
nnoremap < V`]<
" }}}
" smart delete/paste {{{
vnoremap <silent> p "_dP
vnoremap <silent> <leader>d p"_d
vnoremap <silent> <leader>p "_dP
" }}}
" insert mode undo breakpoints {{{
inoremap , ,<c-g>u
inoremap . .<c-g>u
inoremap ; ;<c-g>u
" }}}
" easier completion {{{
inoremap <silent> ,o <C-x><C-o>
inoremap <silent> ,f <C-x><C-f>
inoremap <silent> ,i <C-x><C-i>
inoremap <silent> ,l <C-x><C-l>
inoremap <silent> ,n <C-x><C-n>
inoremap <silent> ,t <C-x><C-]>
inoremap <silent> ,u <C-x><C-u>
" }}}
" insert special chars " {{{
inoremap \sec §
iabbrev n- –
iabbrev m- —

" toggles {{{
nmap ~~ :set autochdir!<BAR>set autochdir?<CR>
nmap ~w :set wrap!<BAR>set wrap?<CR>
nmap ~s :set spell!<BAR>set wrap?<CR>
nmap ~l :set list!<BAR>set list?<CR>
nmap ~n :set number!<BAR>set number?<CR>
" }}}

" command-line {{{
nnoremap ; :

cnoreabbrev !! !./%
cnoreabbrev ?? verbose set?<Left>

cabbr <expr> %% expand('%:p:h')

command! E e!
command! W w!
command! Wq wq!
command! Wqa wqa!

" wildmenu
cnoremap <expr> <Down> wildmenumode() ? "\<C-n>" : "\<Down>"
cnoremap <expr> <Up> wildmenumode() ? "\<C-p>" : "\<Up>"


" § plugins {{{1
" key = vimscript plugin, value = also enabled in nvim
let g:vim_plugins = {
      \ 'christoomey/vim-tmux-navigator': 0,
      \ 'dense-analysis/ale'            : 0,
      \ 'github/copilot.vim'            : 0,
      \ 'jiangmiao/auto-pairs'          : 0,
      \ 'junegunn/fzf.vim'              : 0,
      \ 'junegunn/vim-easy-align'       : 0,
      \ 'lervag/vimtex'                 : 0,
      \ 'tpope/vim-abolish'             : 1,
      \ 'tpope/vim-apathy'              : 1,
      \ 'tpope/vim-commentary'          : 0,
      \ 'tpope/vim-endwise'             : 0,
      \ 'tpope/vim-fugitive'            : 1,
      \ 'tpope/vim-repeat'              : 1,
      \ 'tpope/vim-scriptease'          : 1,
      \ 'tpope/vim-sensible'            : 0,
      \ 'tpope/vim-speeddating'         : 0,
      \ 'tpope/vim-surround'            : 1,
      \ 'tpope/vim-tbone'               : 1,
      \ 'tpope/vim-unimpaired'          : 1,
      \ 'tpope/vim-vinegar'             : 0,
      \ 'vuciv/golf'                    : 0,
      \ '~/GitHub/rdnajac/src/fzf/'     : 0,
      \ }

if has('nvim')
  if !exists('g:loaded_nvim')
    lua require('nvim')
    let g:loaded_nvim = 1
  endif
  let g:ale_disable_lsp = 1
  let g:ale_use_neovim_diagnostics_api = 1
else
  call plug#begin()
  for [plugin, _] in items(g:vim_plugins)
    execute 'Plug' string(plugin)
  endfor
  call plug#end()
  nmap gh vi'C-space>y:silent! !open https://github.com/<C-R>0<CR>
endif

" global variables {{{2

let g:copilot_workspace_folders = ['~/GitHub', '~/.local/share/chezmoi/']

" ALE globals {{{3
let g:ale_fixers = {
      \   '*': ['remove_trailing_lines', 'trim_whitespace'],
      \   'lua': ['stylua'],
      \}
let g:ale_fix_on_save = 0
let g:ale_completion_enabled = 0
let g:ale_linters = {
      \   'lua': ['lua_language_server'],
      \}
let g:ale_linters_explicit = 1
let g:ale_virtualtext_cursor = 'current'
" let g:ale_set_highlights = 0
" }}}1
" vim: fdm=marker fdl=1
