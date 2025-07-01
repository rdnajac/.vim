" vimrc
scriptencoding=utf-8

" Section: settings {{{1
let g:mapleader = ' '
let g:maplocalleader = '\'
let g:VIMDIR = fnamemodify($MYVIMRC, ':p:h')
let g:plug_home = g:VIMDIR . '.plugged/'
let &spellfile = g:VIMDIR . '.spell/en.utf-8.add'
" let &undodir     = s:VIMHOME . '.undo//'
" let &viminfofile = s:VIMHOME . '.viminfo'
" let &verbosefile = s:VIMHOME . '.vimlog.txt'

" options {{{2
set startofline
set autowrite
set autowriteall
" set backup
" set confirm
set fillchars+=diff:╱
set fillchars+=eob:\ ,
set fillchars+=stl:\ ,
set formatoptions-=or
set ignorecase smartcase
set list listchars=trail:¿,tab:→\ "
set mouse=a
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
  " set completeopt+=preinsert
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
" set foldlevelstart=99
set foldminlines=3
set foldopen+=insert,jump
set foldtext=fold#text()

" better search if auto pausing folds
" set foldopen-=search
" nnoremap <silent> / zn/

augroup vimrc_fold
  au!
  " auto_pause_folds
  " au CmdlineLeave /,\? call fold#pause()
  " au CursorMoved,CursorMovedI * call fold#unpause()
  au FileType lua setlocal foldmethod=indent
  au FileType tex setlocal foldmethod=syntax
  au FileType vim setlocal foldmethod=marker
augroup END

nnoremap <expr> h fold#aware_h()

" column {{{3
" TODO: if nonu, set signcolumn=yes
set number signcolumn=number
set numberwidth=4
set signcolumn=auto

" Section: autocmds {{{1
augroup vimrc
  au!
  au BufWritePost $MYVIMRC nested sil! mkview | so $MYVIMRC | sil! lo | echom 'vimrc reloaded'
  au VimEnter * nested call sesh#restore()

  " au WinNew * if bufname('') ==# '' && &bt ==# '' && &ft  | exe 'e #' | endif
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

" for when a ftplugin file is not warranted
au FileType json,jsonc,json5     setlocal conceallevel=0 expandtab
augroup END

" Section: commands {{{1
command! Restart execute 'Obsession ' . g:VIMDIR | restart
command! -bang Quit call quit#buffer(<q-bang>)
command! CleanWhitespace call format#clean_whitespace()
command! Format call format#buffer()

command! -nargs=1 -complete=customlist,bin#scp#complete Scp call bin#scp#scp(<f-args>)

nnoremap <leader>q <Cmd>Quit<CR>
nnoremap <leader>Q <Cmd>Quit!<CR>
nnoremap <leader>fw <Cmd>CleanWhitespace<CR>

" munchies {{{2
command! -bang Scratch execute 'lua require("snacks").scratch' . (<bang>0 ? '.select' : '') .. '()'
command! -bang Zoxide lua require('lazy.spec.snacks.picker.zoxide').pick('<bang>')
command! Autocmds lua Snacks.picker.autocmds()
command! Chezmoi lua require('lazy.spec.snacks.picker.chezmoi')()
command! Config lua Snacks.picker.files({cwd =vim.fn.stdpath('config')})
command! Explorer lua Snacks.picker.explorer()
command! Help lua Snacks.picker.help()
command! Highlights lua Snacks.picker.highlights()
command! Keymaps lua Snacks.picker.keymaps()
command! Lazygit lua Snacks.Lazygit()
command! PluginFiles lua require('lazy.spec.snacks.picker.plugins').files()
command! PluginGrep lua require('lazy.spec.snacks.picker.plugins').grep()
command! Scripts lua require('lazy.spec.snacks.picker.scriptnames')()
command! Terminal lua Snacks.terminal.toggle()

" Section: keymaps {{{1


nnoremap <leader><Space> viW
nnoremap <leader>E  <Cmd>edit!<CR>
nnoremap <leader>e  <Cmd>Explore<CR>
nnoremap <leader>K  <Cmd>norm! K<CR>
nnoremap <leader>R  <Cmd>restart!<CR>
nnoremap <leader>r  <Cmd>Restart<CR>
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
nnoremap <leader>/  <Cmd>lua Snacks.picker.grep()<CR>
nnoremap <leader>,  <Cmd>lua Snacks.picker.buffers()<CR>
nnoremap <leader>bd <Cmd>lua Snacks.bufdelete()<CR>
nnoremap <leader>bD <Cmd>lua Snacks.bufdelete.other()<CR>
" https://github.com/mhinz/vim-galore?tab=readme-ov-file#quickly-edit-your-macros
" nnoremap <leader>M  :<c-u><c-r>V-r>='let @'. v:register .' = '. string(getreg(v:register))<cr><c-f><left>

" code {{{2

" debug {{{2

nnoremap <leader>fR :set ft=<C-R>=&ft<CR><CR>
" nnoremap <leader>fD <Cmd>Rm!<CR>
nnoremap <leader>fD <Cmd>Delete!<CR>

" vim settings {{{2
nnoremap <leader>vv <Cmd>call edit#vimrc()<CR>
nnoremap <leader>va <Cmd>call edit#vimrc('+/Section:\ autocmds')<CR>
nnoremap <leader>vc <Cmd>call edit#vimrc('+/Section:\ commands')<CR>
nnoremap <leader>vk <Cmd>call edit#vimrc('+/Section:\ keymaps')<CR>
nnoremap <leader>vp <Cmd>call edit#vimrc('+/Section:\ plugins')<CR>
nnoremap <leader>vs <Cmd>call edit#vimrc('+/Section:\ settings')<CR>

" nvim settings {{{2
nnoremap <BSlash>i <Cmd>call edit#module('nvim/init')<CR>
nnoremap <BSlash>l <Cmd>call edit#module('lazy/spec/init')<CR>
nnoremap <BSlash>b <Cmd>call edit#module('lazy/bootstrap')<CR>

" find/files {{{2
nnoremap <leader>ft <Cmd>call edit#filetype('after/ftplugin/', '.vim')<CR>
nnoremap <leader>fT <Cmd>call edit#filetype('lua/lazy/lang/', '.lua')<CR>
nnoremap <leader>fs <Cmd>call edit#filetype('snippets/', '.json')<CR>
nnoremap <leader>fC <Cmd>lua Snacks.rename.rename_file()<CR>
nnoremap <leader>ff <Cmd>lua Snacks.picker.files()<CR>
nnoremap <leader>fr <Cmd>lua Snacks.picker.recent()<CR>



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

" lazy {{{2
nnoremap <leader>l <Cmd>Lazy<CR>

" pickers {{{2
nnoremap <leader>p <Cmd>lua Snacks.picker.resume()<CR>
nnoremap <leader>P  <Cmd>lua Snacks.picker()<CR>
nnoremap <leader>n  <Cmd>lua Snacks.picker.notifications()<CR>
" search
nnoremap <leader>s" <Cmd>lua Snacks.picker.registers()<CR>
nnoremap <leader>s/ <Cmd>lua Snacks.picker.search_history()<CR>
nnoremap <leader>s: <Cmd>lua Snacks.picker.command_history()<CR>
nnoremap <leader>sd <Cmd>lua Snacks.picker.diagnostics()<CR>
nnoremap <leader>sj <Cmd>lua Snacks.picker.jumps()<CR>
nnoremap <leader>pq <Cmd>lua Snacks.picker.qflist()<CR>
nnoremap <leader>sh <Cmd>lua Snacks.picker.help()<CR>
nnoremap <leader>sH <Cmd>lua Snacks.picker.highlights()<CR>
nnoremap <leader>si <Cmd>lua Snacks.picker.icons()<CR>
nnoremap <leader>su <Cmd>lua Snacks.picker.undo()<CR>

" debug {{{2
nnoremap <leader>da <Cmd>ALEInfo<CR>
nnoremap <leader>db <Cmd>Blink status<CR>
nnoremap <leader>dc <Cmd>lua=vim.lsp.get_clients()[1].server_capabilities<CR>
nnoremap <leader>dd <Cmd>LazyDev debug<CR>
nnoremap <leader>dl <Cmd>LazyDev lsp<CR>
nnoremap <leader>dh <Cmd>LazyHealth<CR>
nnoremap <leader>dS <Cmd>lua=require('snacks').meta.get()<CR>
nnoremap <leader>dw <Cmd>lua=vim.lsp.buf.list_workspace_folders()<CR>

" XXX: potential conflicts
nnoremap ` ~
nnoremap <BS> <C-o>

" control
nmap <C-c> ciw
vmap <C-s> :sort<CR>

" yank/delete everything
nnoremap yY <Cmd>%y<CR>
nnoremap dD <Cmd>%d<CR>

" available key pairs in normal mode {{{2
" https://gist.github.com/romainl/1f93db9dc976ba851bbb
" `splitjoin`: `gJ` and `gS`
" `vim-surround`: `cs`, `ds`, and `ys`

" cd cm co cp cq cr `cs` cu cx cy cz
nnoremap cdc <Cmd>call bin#cd#smart()<CR>
nnoremap cdb <Cmd>cd %:p:h<BAR>pwd<CR>
nnoremap cdp <Cmd>cd %:p:h:h<BAR>pwd<CR>

" dc dm dq dr `ds` du dx `dy` dz
" vnoremap <silent> dy "_dP
nnoremap dy "_dd

" yc yd ym yo `yp` yq yr `ys` yu yx yz
" vnoremap <silent> yp p"_d

" yank path
nnoremap yp <Cmd>let @*=expand('%:p')<CR>

" vm vo vq `vv` vz
nmap vv Vgc

" `gb` `gc` `gl` `gs` `gy`
nnoremap gb vi'"zy:!open https://github.com/<C-R>z<CR>
xnoremap gb    "zy:!open https://github.com/<C-R>z<CR>

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
nnoremap zq mzgggqG'z


" buffers {{{2
nnoremap <silent> <Tab>         :bnext<CR>
nnoremap <silent> <S-Tab>       :bprev<CR>
nnoremap <silent> <leader><Tab> :e #<CR>

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

" insert mode Undo breakpoints {{{2
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

" insert comment {{{2
function! s:map_insert_comment(lhs, tag) abort
  execute 'nnoremap cO' . a:lhs ':call comment#above("' . a:tag . '")<CR>'
  execute 'nnoremap co' . a:lhs ':call comment#below("' . a:tag . '")<CR>'
endfunction

call s:map_insert_comment('o', '')
call s:map_insert_comment('t', 'TODO')
call s:map_insert_comment('f', 'FIXME')
call s:map_insert_comment('h', 'HACK')
call s:map_insert_comment('b', 'BUG')
call s:map_insert_comment('p', 'PERF')
call s:map_insert_comment('x', 'XXX')

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


" Section: plugins {{{1
" key = vimscript plugin, value = also enabled in nvim
let g:vim_plugins = {
      \ 'dense-analysis/ale'        : 1,
      \ 'github/copilot.vim'        : 0,
      \ 'lervag/vimtex'             : 0,
      \ '~/GitHub/rdnajac/src/fzf/' : 0,
      \ 'junegunn/fzf.vim'          : 0,
      \ 'junegunn/vim-easy-align'   : 1,
      \ 'tpope/vim-commentary'      : 0,
      \ 'tpope/vim-speeddating'     : 0,
      \ 'tpope/vim-vinegar'         : 0,
      \ 'tpope/vim-abolish'         : 1,
      \ 'tpope/vim-apathy'          : 1,
      \ 'tpope/vim-capslock'        : 1,
      \ 'tpope/vim-characterize'    : 1,
      \ 'tpope/vim-endwise'         : 1,
      \ 'tpope/vim-eunuch'          : 1,
      \ 'tpope/vim-git'             : 1,
      \ 'tpope/vim-fugitive'        : 1,
      \ 'tpope/vim-repeat'          : 1,
      \ 'tpope/vim-obsession'       : 1,
      \ 'tpope/vim-rsi'             : 1,
      \ 'tpope/vim-scriptease'      : 1,
      \ 'tpope/vim-sensible'        : 1,
      \ 'tpope/vim-surround'        : 1,
      \ 'tpope/vim-tbone'           : 1,
      \ 'tpope/vim-unimpaired'      : 1,
      \ 'vuciv/golf'                : 0,
      \ 'AndrewRadev/splitjoin.vim' : 1,
      \ 'AndrewRadev/dsf.vim'       : 1,
      \ 'Konfekt/FastFold'          : 0
      \ } 

if has('nvim')
  if !exists('g:loaded_nvim')
    lua require('nvim')
    let g:loaded_nvim = 1
  endif
else
  call plug#begin()
  for [plugin, _] in items(g:vim_plugins)
    execute 'Plug' string(plugin)
  endfor
  call plug#end()
  set clipboard=unnamedplus
  color scheme
endif

" let g:obsession_no_bufenter = 1

xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

" vim:set fdl=2
