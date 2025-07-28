scriptencoding=utf-8

let g:mapleader = ' '
let g:maplocalleader = '\'

set autowrite
set autowriteall
set noswapfile " XXX: do I want this?

" options {{{2
" set confirm
set startofline
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
set splitbelow splitright
set splitkeep=screen
set timeoutlen=420
set updatetime=69
set whichwrap+=<,>,[,],h,l

" indentation {{{3
set breakindent
set linebreak
set nowrap
set shiftround
" don't change shiftwidth or tabstop!
" instead, use `sw` and `sts`
set shiftwidth=2
set softtabstop=2

augroup vimrc_indent
  au!
  au FileType c,sh,zsh        setlocal sw=8 sts=8
  au FileType cpp,cuda,python setlocal sw=4 sts=4
augroup END

" ui {{{2
set lazyredraw
set termguicolors

" columns {{{3
" set foldcolumn=1
set number
set numberwidth=4
set signcolumn=number

" Section: autocmds {{{1
augroup vimrc
  au!
  au BufWritePost $MYVIMRC nested sil! mkview | so $MYVIMRC | sil! lo | echom 'vimrc reloaded'

  " restore cursor position
  au BufWinEnter * exe "silent! normal! g`\"zv"

  " automatically create directories for new files
  " requires `vim-eunuch`
  au BufWritePre ~/ silent! Mkdir

  " immediately quit the command line window
  au CmdwinEnter * quit

  " automatically reload files that have been changed outside of Vim
  au FocusGained * if &buftype !=# 'nofile' | checktime | endif

  " TODO move these to a separate group {{{3
  au FileType json,jsonc,json5     setlocal conceallevel=0 expandtab
  " automatically resize splits when the window is resized
  au VimResized * let t = tabpagenr() | tabdo wincmd = | execute 'tabnext' t

  " no cursorline in insert mode
  au InsertLeave,WinEnter * setlocal cursorline
  au InsertEnter,WinLeave * setlocal nocursorline

  " relative numbers in visual mode only if number is already set
  au ModeChanged [vV\x16]*:* if &l:nu| let &l:rnu = mode() =~# '^[vV\x16]' | endif
  au ModeChanged *:[vV\x16]* if &l:nu| let &l:rnu = mode() =~# '^[vV\x16]' | endif
  au WinEnter,WinLeave *     if &l:nu| let &l:rnu = mode() =~# '^[vV\x16]' | endif
  " }}}3

augroup END

" Section: keymaps {{{1
nnoremap ,, <Cmd>lua Snacks.picker.buffers()<CR>
nnoremap <leader>! <Cmd>call redir#prompt()<CR>
nnoremap <leader><Space> viW

nnoremap <leader>K  <Cmd>norm K<CR>

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

" nnoremap <leader>fp :FindPlugin<CR>
" nnoremap <leader>sp :GrepPlugin<CR>
nnoremap <leader>fP :FindPlugin!<CR>
nnoremap <leader>sP :GrepPlugin!<CR>

" code {{{2
" https://github.com/mhinz/vim-galore?tab=readme-ov-file#quickly-edit-your-macros
" nnoremap <leader>M  :<c-u><c-r>V-r>='let @'. v:register .' = '. string(getreg(v:register))<cr><c-f><left>
" nnoremap <expr> <leader>M ':let @'.v:register.' = '.string(getreg(v:register))."\<CR>\<C-f>\<Left>"

" debug {{{2
nnoremap <leader>da <Cmd>ALEInfo<CR>
nnoremap <leader>db <Cmd>Blink status<CR>
nnoremap <leader>dc <Cmd>=vim.lsp.get_clients()[1].server_capabilities<CR>
nnoremap <leader>dd <Cmd>LazyDev debug<CR>
nnoremap <leader>dl <Cmd>LazyDev lsp<CR>
nnoremap <leader>dh <Cmd>LazyHealth<CR>
nnoremap <leader>dS <Cmd>=require('snacks').meta.get()<CR>
nnoremap <leader>dw <Cmd>=vim.lsp.buf.list_workspace_folders()<CR>

nnoremap <leader>fR :set ft=<C-R>=&ft<CR><CR>
" nnoremap <leader>fD <Cmd>Rm!<CR>
nnoremap <leader>fD <Cmd>Delete!<CR>
nnoremap <leader>fw <Cmd>CleanWhitespace<CR>

" vim settings `<leader>v` {{{2
nnoremap <leader>vv <Cmd>call edit#vimrc()<CR>
nnoremap <leader>va <Cmd>call edit#vimrc('+/autocmds')<CR>
nnoremap <leader>vc <Cmd>call edit#vimrc('+/commands')<CR>
nnoremap <leader>vk <Cmd>call edit#vimrc('+/keymaps')<CR>
nnoremap <leader>vp <Cmd>call edit#vimrc('+/plugins')<CR>
nnoremap <leader>vs <Cmd>call edit#vimrc('+/settings')<CR>
nnoremap <leader>vu <Cmd>call edit#vimrc('+/ui')<CR>

" nvim settings {{{2
nnoremap <BSlash>i <Cmd>call edit#module('init')<CR>
nnoremap <BSlash>n <Cmd>call edit#module('nvim/init')<CR>
nnoremap <BSlash>p <Cmd>call edit#module('nvim/plugins/init')<CR>
nnoremap <BSlash>m <Cmd>call edit#module('munchies/init')<CR>
nnoremap <BSlash>0 <Cmd>call edit#readme()<CR>

" find/files {{{2
nnoremap <leader>ft <Cmd>call edit#filetype()<CR>
nnoremap <leader>fT <Cmd>call edit#filetype('/after/ftplugin/', '.lua')<CR>
nnoremap <leader>fT <Cmd>call edit#filetype('lua/lazy/lang/', '.lua')<CR>
nnoremap <leader>fs <Cmd>call edit#filetype('snippets/', '.json')<CR>
nnoremap <leader>fm <Cmd>lua Snacks.rename.rename_file()<CR>
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
nnoremap <leader>sq <Cmd>lua Snacks.picker.qflist()<CR>
nnoremap <leader>sh <Cmd>lua Snacks.picker.help()<CR>
nnoremap <leader>sH <Cmd>lua Snacks.picker.highlights()<CR>
nnoremap <leader>si <Cmd>lua Snacks.picker.icons()<CR>
nnoremap <leader>su <Cmd>lua Snacks.picker.undo()<CR>

" XXX: potential conflicts
nnoremap ` ~
nnoremap <BS> <C-o>

" control
nmap  ciw
vmap  :sort<CR>

" yank/delete everything
nnoremap yY <Cmd>%y<CR>
nnoremap dD <Cmd>%d<CR>

" available key pairs in normal mode {{{2
" https://gist.github.com/romainl/1f93db9dc976ba851bbb
" `splitjoin`: `gJ` and `gS`
" `vim-surround`: `cs`, `ds`, and `ys`

" `cd` cm co cp `cq` cr `cs` cu cx cy cz
" plugin/cd.vim
nmap <expr> cq change#quote()

" dc dm dq dr `ds` du dx `dy` dz
" vnoremap <silent> dy "_dP
nnoremap dy "_dd

" yc yd ym `yo` `yp` yq yr `ys` yu yx yz
" vnoremap <silent> yp p"_d

" yank path
nnoremap yp <Cmd>let @*=expand('%:p')<CR>

" vm vo vq `vv` vz
nmap vv Vgc

" `gb` `gc` `gl` `gs` `gy`
nnoremap gb vi'"zy:!open https://github.com/<C-R>z<CR>
xnoremap gb    "zy:!open https://github.com/<C-R>z<CR>

nmap gl <Cmd>Config<CR>
nmap gy "xyygcc"xp

" `surround` {{{2
nmap S viWS
" nmap yss ys

" `zq` ZA ... ZP, `ZQ` ... `ZZ`
nmap zq gqag

" vim-unimpaired
nmap zJ ]ekJ

" text objects {{{2
" Buffer pseudo-text objects
xnoremap ig :<C-u>let z = @/\|1;/^./kz<CR>G??<CR>:let @/ = z<CR>V'z
onoremap ig :<C-u>normal vig<CR>
xnoremap ag GoggV
onoremap ag :<C-u>normal vag<CR>

" buffers {{{2
nnoremap <silent> <Tab>         :bprev<CR>
nnoremap <silent> <S-Tab>       :bnext<CR>
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

" insert pluginsial chars {{{2
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

" TODO: restore plugins, don't keep commands here
command! -bang Quit call quit#buffer(<q-bang>)

command! -nargs=1 -complete=customlist,bin#scp#complete Scp call bin#scp#scp(<f-args>)

if has('nvim')
  finish
endif
set clipboard=unnamed
color scheme
call plug#begin(vim#vim#home() . '/pack/plugged')
Plug 'alker0/chezmoi.vim',
Plug 'github/copilot.vim',
Plug 'lervag/vimtex'

" dev
Plug 'tpope/vim-tbone'
Plug 'tpope/vim-eunuch'

" start
Plug 'tpope/vim-git'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-rsi'
Plug 'tpope/vim-surround'

" opt
Plug 'tpope/vim-apathy'
Plug 'tpope/vim-capslock'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-characterize'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-scriptease'
Plug 'tpope/vim-unimpaired'

" TODO: try mini.splitjoin
Plug 'AndrewRadev/splitjoin.vim'

" replaced with native plugins
Plug 'AndrewRadev/dsf.vim'
Plug 'tpope/vim-tbone',

" needs configureation
Plug 'dense-analysis/ale'

" not used in nvim
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-vinegar'
Plug 'Konfekt/FastFold'

" using mini instead
Plug 'junegunn/vim-easy-align'
Plug 'folke/snacks.nvim'

" games
Plug 'vim/killersheep'
Plug 'vuciv/golf'

" try the shipped vim9 comment plugin
Plug 'tpope/vim-commentary'
call plug#end()

" vim:set fdl=2

