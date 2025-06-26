" vimrc
scriptencoding=utf-8

" § settings {{{1
let g:mapleader = ' '
let g:maplocalleader = '\'
let g:VIMDIR = fnamemodify($MYVIMRC, ':p:h')
let &spellfile = g:VIMDIR . '.spell/en.utf-8.add'
" let &undodir     = s:VIMHOME . '.undo//'
" let &viminfofile = s:VIMHOME . '.viminfo'
" let &verbosefile = s:VIMHOME . '.vimlog.txt'

" options {{{2
set autowrite
" set backup
" set confirm
set fillchars+=diff:╱,
set fillchars+=eob:\ ,
set fillchars+=stl:\ ,
set formatoptions-=or
set ignorecase smartcase
set list listchars=trail:¿,tab:→\ "
set mouse=a
set noruler
set pumheight=10
set report=0
set scrolloff=8
set shortmess+=aAcCI
set shortmess-=o
set showmatch
" set showtabline=2
set splitbelow splitright
set splitkeep=screen
set termguicolors
set timeoutlen=420
set updatetime=69
set undofile undolevels=10000
set whichwrap+=<,>,[,],h,l

set completeopt=menu,preview,longest
if has('nvim') || has('patch-9.1.1337')
  set completeopt+=preinsert
endif

" indentation {{{3
set breakindent
set linebreak
set nowrap
set shiftround
" don't change shiftwidth or tabstop! instead, use sw and sts
set shiftwidth=2
set softtabstop=2

augroup vimrc_indent
  au!
  au FileType c,sh,zsh        setlocal sw=8 sts=8
  au FileType cpp,cuda,python setlocal sw=4 sts=4
augroup END

" folding {{{3
set fillchars+=fold:\ ,
set fillchars+=foldclose:▸,
set fillchars+=foldopen:▾,
set fillchars+=foldsep:\ ,
set fillchars+=foldsep:│
set foldlevel=1
set foldlevelstart=99
set foldminlines=3
set foldopen+=insert,jump
set foldtext=fold#text()

augroup vimrc_fold
  au!
  au FileType lua setlocal foldmethod=indent
  au FileType tex setlocal foldmethod=syntax
  au FileType vim setlocal foldmethod=marker
augroup END

" column {{{3
" TODO: if nonu, set signcolumn=yes
set number signcolumn=number
set numberwidth=4
" set signcolumn=yes
" }}}1

" § autocmds {{{1
augroup vimrc " {{{2
  au!
  au BufWritePost $MYVIMRC nested source $MYVIMRC | echom 'vimrc reloaded'

  " restore cursor position (and open any folds) when opening a file
  " au BufWinEnter * let l = line("'\"") | if l >= 1 && l <= line("$") | execute "normal! g`\"zv" | endif
  au BufWinEnter * exe "silent! normal! g`\"zv"

  " automatically create directories for new files
  au BufWritePre * call bin#mkdir#mkdir(expand('<afile>'))

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
augroup END

augroup vimrc_filetype " {{{2
  " for when a ftplugin file is not warranted
  au!
  au FileType json,jsonc,json5     setlocal conceallevel=0 expandtab
  au FileType tmux,sshconfig,mason setlocal iskeyword+=-
augroup END

augroup SetLocalPath " {{{2
  " TODO: move to local apathy plugin
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
" }}}1

" § commands {{{1
command! -bang Quit call quit#buffer(<q-bang>)
command! CleanWhitespace call format#clean_whitespace()
command! Format call format#buffer()

nnoremap <leader>q <Cmd>Quit<CR>
nnoremap <leader>Q <Cmd>Quit!<CR>
nnoremap <leader>fw <Cmd>CleanWhitespace<CR>

" vim commands for Snacks functions
command! Explorer lua Snacks.picker.explorer({cwd = vim.cmd.pwd()})
command! Keymaps lua Snacks.picker.keymaps()
command! Highlights lua Snacks.picker.highlights()
command! Terminal lua Snacks.terminal.toggle()
command! Chezmoi lua require('lazy.spec.snacks.picker.chezmoi')()
command! Scripts lua require('lazy.spec.snacks.picker.scriptnames')()
command! PluginGrep lua require('lazy.spec.snacks.picker.plugins').grep()
command! PluginFiles lua require('lazy.spec.snacks.picker.plugins').files()
command! -bang Zoxide lua require('lazy.spec.snacks.picker.zoxide').pick('<bang>')
command! Help lua Snacks.picker.help()
command! Lazygit :lua Snacks.Lazygit()
command! Config :lua Snacks.picker.files({cwd =vim.fn.stdpath('config')})
command! -bang Scratch execute 'lua require("snacks").scratch' . (<bang>0 ? '.select' : '') .. '()'
" }}}1

" § keymaps {{{1
nnoremap <leader><Space> viW
nnoremap <leader>E  <Cmd>edit!<CR>
nnoremap <leader>e  <Cmd>Explore<CR>
nnoremap <leader>K  <Cmd>norm! K<CR>
nnoremap <leader>R  <Cmd>restart!<CR>
nnoremap <leader>r  <Cmd>restart<CR>
nnoremap <leader>S  <Cmd>Scriptnames<CR>
nnoremap <leader>.  <Cmd>Scratch<CR>
nnoremap <leader>>  <Cmd>Scratch!<CR>
nnoremap <leader>i  <Cmd>help index<CR>
nnoremap <leader>m  <Cmd>messages<CR>
nnoremap <leader>h  <Cmd>Help<CR>
nnoremap <leader>t  <Cmd>edit #<CR>
nnoremap <leader>w  <Cmd>write!<CR>
nnoremap <leader>z  <Cmd>Zoxide<CR>
nnoremap <leader>cz <Cmd>Chezmoi<CR>
nnoremap <leader>fp <Cmd>PluginFiles<CR>
nnoremap <leader>sp <Cmd>PluginGrep<CR>
" https://github.com/mhinz/vim-galore?tab=readme-ov-file#quickly-edit-your-macros
" nnoremap <leader>M  :<c-u><c-r>V-r>='let @'. v:register .' = '. string(getreg(v:register))<cr><c-f><left>

nnoremap <leader>fR :set ft=<C-R>=&ft<CR><CR>
nnoremap <leader>fD <Cmd>Delete!<CR>

nnoremap <leader>ft <Cmd>call edit#filetype('after/ftplugin/', '.vim')<CR>
nnoremap <leader>fT <Cmd>call edit#filetype('lua/lazy/lang/', '.lua')<CR>
nnoremap <leader>fs <Cmd>call edit#filetype('snippets/', '.json')<CR>

nnoremap <leader>va <Cmd>vsplit +/§\ autocmds $MYVIMRC<CR>zvzz
nnoremap <leader>vc <Cmd>vsplit +/§\ commands $MYVIMRC<CR>zvzz
nnoremap <leader>vk <Cmd>vsplit +/§\ keymaps $MYVIMRC<CR>zvzz
nnoremap <leader>vp <Cmd>vsplit +/§\ plugins $MYVIMRC<CR>zvzz
nnoremap <leader>vs <Cmd>vsplit +/§\ settings $MYVIMRC<CR>zvzz
nnoremap <leader>va <Cmd>call edit#vimrc('+/§\ autocmds')<CR>
nnoremap <leader>vc <Cmd>call edit#vimrc('+/§\ commands')<CR>
nnoremap <leader>vk <Cmd>call edit#vimrc('+/§\ keymaps')<CR>
nnoremap <leader>vp <Cmd>call edit#vimrc('+/§\ plugins')<CR>
nnoremap <leader>vs <Cmd>call edit#vimrc('+/§\ settings')<CR>


nnoremap <leader>v <Cmd>call edit#vimrc()<CR>
nnoremap <BSlash>a <Cmd>call edit#module('nvim/autocmds')<CR>
nnoremap <BSlash>i <Cmd>call edit#module('nvim/init')<CR>
nnoremap <BSlash>k <Cmd>call edit#module('nvim/keymaps')<CR>
nnoremap <BSlash>o <Cmd>call edit#module('nvim/options')<CR>
nnoremap <BSlash>h <Cmd>call edit#module('nvim/hacks')<CR>
nnoremap <BSlash>l <Cmd>call edit#module('lazy/spec/init')<CR>
nnoremap <BSlash>b <Cmd>call edit#module('lazy/bootstrap')<CR>

nnoremap <leader>bd :lua Snacks.bufdelete()<CR>

nnoremap <leader>fC :lua Snacks.rename.rename_file()<CR>
nnoremap <leader>ff :lua Snacks.picker.files()<CR>
nnoremap <leader>fr :lua Snacks.picker.recent()<CR>

nnoremap <leader>gb <Cmd>lua Snacks.picker.git_log_line()<CR>
nnoremap <leader>gB <Cmd>lua Snacks.gitbrowse()<CR>
nnoremap <leader>gd <Cmd>lua Snacks.picker.git_diff()<CR>
nnoremap <leader>gs <Cmd>lua Snacks.picker.git_status()<CR>
nnoremap <leader>gS <Cmd>lua Snacks.picker.git_stash()<CR>
nnoremap <leader>ga <Cmd>!git add %<CR>
nnoremap <leader>gg <Cmd>lua Snacks.lazygit()<CR>
nnoremap <leader>gf <Cmd>lua Snacks.picker.git_log_file()<CR>
nnoremap <leader>gl <Cmd>lua Snacks.picker.git_log()<CR>

nnoremap <leader>l <Cmd>Lazy<CR>
nnoremap <leader>n :lua Snacks.picker.notifications()<CR>

nnoremap <leader>P  <Cmd>lua Snacks.picker()<CR>
nnoremap <leader>p" <Cmd>lua Snacks.picker.registers()<CR>
nnoremap <leader>p/ <Cmd>lua Snacks.picker.search_history()<CR>
nnoremap <leader>pD <Cmd>lua Snacks.picker.diagnostics_buffer()<CR>

command! Autocmds lua Snacks.picker.autocmds()
nnoremap <leader>pa <Cmd>lua Snacks.picker.autocmds()<CR>

nnoremap <leader>pc <Cmd>lua Snacks.picker.commands()<CR>
nnoremap <leader>p: <Cmd>lua Snacks.picker.command_history()<CR>
nnoremap <leader>pd <Cmd>lua Snacks.picker.diagnostics()<CR>
nnoremap <leader>ph <Cmd>lua Snacks.picker.highlights()<CR>
nnoremap <leader>pi <Cmd>lua Snacks.picker.icons()<CR>
nnoremap <leader>pj <Cmd>lua Snacks.picker.jumps()<CR>
nnoremap <leader>pk <Cmd>lua Snacks.picker.keymaps()<CR>
nnoremap <leader>pp <Cmd>lua Snacks.picker.resume()<CR>
nnoremap <leader>pq <Cmd>lua Snacks.picker.qflist()<CR>
nnoremap <leader>sa <Cmd>lua Snacks.picker.autocmds()<CR>
nnoremap <leader>sC <Cmd>lua Snacks.picker.commands()<CR>
nnoremap <leader>sh <Cmd>lua Snacks.picker.help()<CR>
nnoremap <leader>/ <Cmd>lua Snacks.picker.grep()<CR>
nnoremap <leader>sH <Cmd>lua Snacks.picker.highlights()<CR>
nnoremap <leader>si <Cmd>lua Snacks.picker.icons()<CR>
nnoremap <leader>sk <Cmd>lua Snacks.picker.keymaps()<CR>
nnoremap <leader>su <Cmd>lua Snacks.picker.undo()<CR>

" XXX: conflicts
nnoremap ` ~
nnoremap <BS> <C-o>

" control
nmap <C-c> ciw
vmap <C-s> :sort<CR>

" available key pairs in normal mode {{{2
" https://gist.github.com/romainl/1f93db9dc976ba851bbb
" `splitjoin`: `gJ` and `gS`
" `vim-surround`: `cs`, `ds`, and `ys`

" cd cm co cp cq cr cs cu cx cy cz
nnoremap cdc <Cmd>call bin#cd#smart()<CR>
nnoremap cdb <Cmd>cd %:p:h<BAR>pwd<CR>
nnoremap cdp <Cmd>cd %:p:h:h<BAR>pwd<CR>

" dc dm dq dr ds du dx `dy` dz
" vnoremap <silent> dy "_dP
nnoremap dy "_dd

" yc yd ym yo yp yq yr ys yu yx yz
" vnoremap <silent> yp p"_d

" vm vo vq `vv` vz
nmap vv Vgc

" `gb` `gc` gl `gs` `gy`
" TODO: use different register
nmap gb vi'y:!open https://github.com/<C-R>0<CR>
xnoremap gb y:!open https://github.com/<C-R>0<CR>
nmap gy "xyygcc"xp
nmap gl <Cmd>Config<CR>

" `surround` {{{2
vmap `  S`
vmap '  S'
vmap "  S"
vmap b  Sb
nmap S  viWS
" nmap yss ys

" `zq` ZA ... ZP, `ZQ` ... `ZZ`
nmap zq gggqG

" buffers {{{2
nnoremap <silent> <Tab>         :bnext<CR>
nnoremap <silent> <S-Tab>       :bprev<CR>
nnoremap <silent> <leader><Tab> :e #<CR>
nnoremap <silent> <leader>bD    :bd<CR>

" Close buffer
map <silent> <C-q> <Cmd>bd<CR>

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
inoremap \sec §
iabbrev n- –
iabbrev m- —

" cmdline {{{2
nnoremap ; :

cnoreabbrev <expr> %% expand('%:p:h')
cnoreabbrev !! !./%
cnoreabbrev scp !./%
cnoreabbrev ?? verbose set?<Left>
cnoreabbrev <expr> scp getcmdtype() == ':' && getcmdline() =~ '^scp' ? '!scp %' : 'scp'
cnoreabbrev <expr> require getcmdtype() == ':' && getcmdline() =~ '^require' ? 'lua require' : 'require'
cnoreabbrev <expr> man (getcmdtype() ==# ':' && getcmdline() =~# '^man\s*$') ? 'Man' : 'man'
cnoreabbrev <expr> Snacks getcmdtype() == ':' && getcmdline() =~ '^Snacks' ? 'lua Snacks' : 'Snacks'
cnoreabbrev <expr> snacks getcmdtype() == ':' && getcmdline() =~ '^snacks' ? 'lua Snacks' : 'snacks'


command! E e!
command! W w!
command! Wq wq!
command! Wqa wqa!

cnoremap <expr> <Down> wildmenumode() ? "\<C-n>" : "\<Down>"
cnoremap <expr> <Up> wildmenumode() ? "\<C-p>" : "\<Up>"
" }}}1

" § plugins {{{1
" key = vimscript plugin, value = also enabled in nvim
let g:vim_plugins = {
      \ 'dense-analysis/ale'        : 0,
      \ 'github/copilot.vim'        : 0,
      \ 'lervag/vimtex'             : 0,
      \ '~/GitHub/rdnajac/src/fzf/' : 0,
      \ 'junegunn/fzf.vim'          : 0,
      \ 'junegunn/vim-easy-align'   : 1,
      \ 'tpope/vim-abolish'         : 1,
      \ 'tpope/vim-apathy'          : 1,
      \ 'tpope/vim-commentary'      : 0,
      \ 'tpope/vim-endwise'         : 0,
      \ 'tpope/vim-fugitive'        : 1,
      \ 'tpope/vim-repeat'          : 1,
      \ 'tpope/vim-obsession'       : 1,
      \ 'tpope/vim-rsi'             : 1,
      \ 'tpope/vim-scriptease'      : 1,
      \ 'tpope/vim-sensible'        : 0,
      \ 'tpope/vim-speeddating'     : 0,
      \ 'tpope/vim-surround'        : 1,
      \ 'tpope/vim-tbone'           : 0,
      \ 'tpope/vim-unimpaired'      : 0,
      \ 'tpope/vim-vinegar'         : 0,
      \ 'vuciv/golf'                : 0,
      \ 'AndrewRadev/splitjoin.vim' : 1,
      \ 'Konfekt/FastFold'          : 0
      \ }

if has('nvim')
  if !exists('g:loaded_nvim')
    lua require('nvim')
    command! LazyHealth Lazy! load all | checkhealth
    let g:loaded_nvim = 1
  endif
else
  call plug#begin()
  for [plugin, _] in items(g:vim_plugins)
    execute 'Plug' string(plugin)
  endfor
  call plug#end()
  set clipboard=unnamedplus
endif

" global variables {{{2
let g:copilot_workspace_folders = ['~/GitHub', '~/.local/share/chezmoi/']

function! PrettyPath() abort
  let ret = ''
  " if exists('*luaeval')
  let l:prefix = luaeval('require("lazy.spec.ui.lualine.components.path").prefix[1]()')
  let l:suffix = luaeval('require("lazy.spec.ui.lualine.components.path").suffix[1]()')
  let l:mod = luaeval('require("lazy.spec.ui.lualine.components.path").modified[1]()')
  let ret .= '%#lualine_a_chromatophore#'
  let ret .= ' '
  let ret .= l:prefix
  let ret .= '%#lualine_ab_chromatophore#'
  let ret .= '🭛'
  let ret .= '%#lualine_b_chromatophore#'
  let ret .= l:suffix
  return ret
endfunction

function! MyStatusLine() abort
  let l:statusline = ''
  let l:statusline .= PrettyPath()
  let l:statusline .= &ro ? ' ' : ''
  let l:statusline .= &ft ==# 'help' ? '%h' : ''
  let l:statusline .= &mod ? '  ' : ''

  " let l:statusline .= '%='
  " let l:statusline .= '%k'
  " let l:statusline .= '%S'
  " let l:statusline .= ' [%2v,%P]'
  return l:statusline
endfunction

set showcmdloc=statusline
" set statusline=%!MyStatusLine()
" set winbar=%!MyStatusLine()
" set tabline=%!MyStatusLine()
" set statusline=%!MyStatusLine()
" set laststatus=0

" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)
" vim:set fdl=2

