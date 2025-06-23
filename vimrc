" vimrc
scriptencoding=utf-8

" § settings {{{1
let g:mapleader = ' '
let g:maplocalleader = '\'
" housekeeping {{{2
let s:VIMHOME = expand('$HOME/.config/vim//')
let g:plug_home = s:VIMHOME . './plugged//'
let &spellfile = s:VIMHOME . '.spell/en.utf-8.add'
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
set showtabline=2
set splitbelow splitright
set splitkeep=screen
set termguicolors
set timeoutlen=420
set updatetime=69
set undofile undolevels=10000
set whichwrap+=<,>,[,],h,l

set completeopt=menu,preview,preinsert,longest
" set completeopt=menu,preview,longest
set wildmode=longest:full,full

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

augroup vimrc_fold
  au!
  au FileType lua setlocal foldmethod=indent
  au FileType tex setlocal foldmethod=syntax
  au FileType vim setlocal foldmethod=marker
augroup END

" column {{{3
" set number signcolumn=number
set numberwidth=3
set signcolumn=yes
" TOOD: if nonu, set signcolumn=yes

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
  au InsertLeave,WinEnter * set cursorline
  au InsertEnter,WinLeave * set nocursorline

  " relative numbers in visual mode only if number is already set
  au ModeChanged [vV\x16]*:* if &l:nu| let &l:rnu = mode() =~# '^[vV\x16]' | endif
  au ModeChanged *:[vV\x16]* if &l:nu| let &l:rnu = mode() =~# '^[vV\x16]' | endif
  au WinEnter,WinLeave *     if &l:nu| let &l:rnu = mode() =~# '^[vV\x16]' | endif
augroup END

augroup vimrc_filetype " {{{2
  " for when a ftplugin file is not warranted
  au!
  au FileType json,jsonc,json5     setl conceallevel=0
  au FileType tmux,sshconfig,mason setl iskeyword+=-
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
command! -bar -bang -nargs=+ Chmod execute bin#chmod#chmod(<bang>0, <f-args>)
command! -bar -bang          Delete call bin#delete#delete(<bang>0)
command! -nargs=1 -complete=customlist,bin#scp#complete Scp call bin#scp#scp(<f-args>)

command! InstallTools lua require('nvim.util.installer').mason_install()

command! -bang Quit call quit#buffer(<q-bang>)
nnoremap <leader>q <Cmd>Quit<CR>
nnoremap <leader>Q <Cmd>Quit!<CR>

command! CleanWhitespace call format#whitespace()
nnoremap <leader>fw <cmd>CleanWhitespace<CR>

command! Format call format#buffer()
nmap zq <Cmd>Format<CR>

" vim commands for Snacks functions
command! Autocmds lua Snacks.picker.autocmds({confirm = 'edit'})
command! Keymaps lua Snacks.picker.keymaps({confirm = 'edit', layout = {preset = 'mylayout'}})
command! Highlights lua Snacks.picker.highlights()
command! ToggleSnacksTerm lua Snacks.terminal.toggle()
command! Chezmoi lua require('munchies.picker.chezmoi')()
command! Scripts lua require('munchies.picker.scriptnames')()
command! PluginGrep lua require('munchies.picker.plugins').grep()
command! PluginFiles lua require('munchies.picker.plugins').files()
command! -bang Zoxide lua require('munchies.picker.zoxide').pick('<bang>')

command! Lazygit :lua Snacks.Lazygit()

" § keymaps {{{1
nnoremap <leader><Space> viW
nnoremap <leader>E <Cmd>edit!<CR>
nnoremap <leader>K <Cmd>norm! K<CR>
nnoremap <leader>R <Cmd>restart!<CR>
nnoremap <leader>S <Cmd>Scriptnames<CR>
nnoremap <leader>i <Cmd>help index<CR>
nnoremap <leader>m <Cmd>messages<CR>
nnoremap <leader>r :Restart<CR>
nnoremap <leader>t <Cmd>edit #<CR>
nnoremap <leader>w <Cmd>write!<CR>
nnoremap <leader>z <Cmd>Zoxide<CR>
nnoremap <leader>cz <Cmd>Chezmoi<CR>
nnoremap <leader>fp <Cmd>PluginFiles<CR>
nnoremap <leader>sp <Cmd>PluginGrep<CR>
" https://github.com/mhinz/vim-galore?tab=readme-ov-file#quickly-edit-your-macros
" nnoremap <leader>M  :<c-u><c-r><c-r>='let @'. v:register .' = '. string(getreg(v:register))<cr><c-f><left>

nnoremap <leader>va <Cmd>edit +/§\ autocmds $MYVIMRC<CR>zvzz
nnoremap <leader>vc <Cmd>edit +/§\ commands $MYVIMRC<CR>zvzz
nnoremap <leader>vk <Cmd>edit +/§\ keymaps $MYVIMRC<CR>zvzz
nnoremap <leader>vp <Cmd>edit +/§\ plugins $MYVIMRC<CR>zvzz
nnoremap <leader>vs <Cmd>edit +/§\ settings $MYVIMRC<CR>zvzz
nnoremap <leader>vv <Cmd>edit $MYVIMRC<CR>

function! s:edit(relpath, ext)
  let suffix = empty(&filetype) ? '' : &filetype . a:ext
  execute 'edit ' . fnamemodify($MYVIMRC, ':p:h') . '/' . a:relpath . suffix
endfunction

nnoremap <leader>ft :call <SID>edit('after/ftplugin/', '.vim')<CR>
nnoremap <leader>fT :call <SID>edit('lua/lazy/lang/', '.lua')<CR>
nnoremap <leader>fs :call <SID>edit('snippets/', '.json')<CR>
nnoremap <leader>fR :set ft=<C-R>=&ft<CR><CR>
nnoremap <leader>fD <Cmd>Delete!<CR>

nnoremap <leader>. :lua Snacks.scratch()<CR>
nnoremap <leader>> :lua Snacks.scratch.select()<CR>
nnoremap <leader>, :lua Snacks.picker.buffers()<CR>
nnoremap <leader>/ :lua Snacks.picker.grep()<CR>
nnoremap <leader>F :lua Snacks.picker.smart()<CR>

nnoremap <leader>bd :lua Snacks.bufdelete()<CR>
nnoremap <leader>h :lua Snacks.picker.help()<CR>

nnoremap <leader>fC :lua Snacks.rename.rename_file()<CR>
nnoremap <leader>ff :lua Snacks.picker.files()<CR>
nnoremap <leader>fr :lua Snacks.picker.recent()<CR>

nnoremap <leader>gb :lua Snacks.picker.git_log_line()<CR>
nnoremap <leader>gB :lua Snacks.gitbrowse()<CR>
nnoremap <leader>gd :lua Snacks.picker.git_diff()<CR>
nnoremap <leader>gs :lua Snacks.picker.git_status()<CR>
nnoremap <leader>gS :lua Snacks.picker.git_stash()<CR>
nnoremap <leader>ga :!git add %<CR>
nnoremap <leader>gg :lua Snacks.lazygit()<CR>
nnoremap <leader>gf :lua Snacks.picker.git_log_file()<CR>
nnoremap <leader>gl :lua Snacks.picker.git_log()<CR>

nnoremap <leader>l <Cmd>Lazy<CR>
nnoremap <leader>n :lua Snacks.picker.notifications()<CR>

nnoremap <leader>P :lua Snacks.picker()<CR>
nnoremap <leader>p" :lua Snacks.picker.registers()<CR>
nnoremap <leader>p/ :lua Snacks.picker.search_history()<CR>
nnoremap <leader>pD :lua Snacks.picker.diagnostics_buffer()<CR>
nnoremap <leader>pa :lua Snacks.picker.autocmds()<CR>
nnoremap <leader>pc :lua Snacks.picker.commands()<CR>
nnoremap <leader>p: :lua Snacks.picker.command_history()<CR>
nnoremap <leader>pd :lua Snacks.picker.diagnostics()<CR>
nnoremap <leader>ph :lua Snacks.picker.highlights()<CR>
nnoremap <leader>pi :lua Snacks.picker.icons()<CR>
nnoremap <leader>pj :lua Snacks.picker.jumps()<CR>
nnoremap <leader>pk :lua Snacks.picker.keymaps()<CR>
nnoremap <leader>pp :lua Snacks.picker.resume()<CR>
nnoremap <leader>pq :lua Snacks.picker.qflist()<CR>

nnoremap <leader>sa :lua Snacks.picker.autocmds()<CR>
nnoremap <leader>sC :lua Snacks.picker.commands()<CR>
nnoremap <leader>sh :lua Snacks.picker.help()<CR>
nnoremap <leader>sH :lua Snacks.picker.highlights()<CR>
nnoremap <leader>si :lua Snacks.picker.icons()<CR>
nnoremap <leader>sk :lua Snacks.picker.keymaps()<CR>
nnoremap <leader>su :lua Snacks.picker.undo()<CR>

" XXX: conflicts
nnoremap ` ~
nnoremap <BS> <C-o>

" control
nmap <C-c> ciw
vmap <C-s> :sort<CR>

" available key pairs in normal mode {{{2
" https://gist.github.com/romainl/1f93db9dc976ba851bbb
" `splitjoin`: gJ and gS
" `vim-surround`: cs, ds, and ys

" cd cm co cp cq cr cs cu cx cy cz
nnoremap cdc <Cmd>call bin#cd#smart()<CR>
nnoremap cdb <Cmd>cd %:p:h<BAR>pwd<CR>
nnoremap cdp <Cmd>cd %:p:h:h<BAR>pwd<CR>

" dc dm dq dr ds du dx dy dz
" vnoremap <silent> dy "_dP
nnoremap dy "_dd

" yc yd ym yo yp yq yr ys yu yx yz
" vnoremap <silent> yp p"_d

" vm vo vq vv vz
nmap vv Vgc

" gb gc gl gs gy
nmap gb viqy:!open https://github.com/<C-R>0<CR>
xnoremap gb y:!open https://github.com/<C-R>0<CR>
nmap gy "xyygcc"xp

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

" `surround` {{{2
vmap `  S`
vmap '  S'
vmap "  S"
vmap b  Sb
nmap S  viWS
" nmap yss ys

" cmdline {{{2
nnoremap ; :

cnoreabbrev <expr> %% expand('%:p:h')
cnoreabbrev !! !./%
cnoreabbrev ?? verbose set?<Left>
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

" § plugins {{{1
" key = vimscript plugin, value = also enabled in nvim
let g:vim_plugins = {
      \ 'dense-analysis/ale'        : 0,
      \ 'github/copilot.vim'        : 0,
      \ 'lervag/vimtex'             : 0,
      \ '~/GitHub/rdnajac/src/fzf/' : 0,
      \ 'junegunn/fzf.vim'          : 0,
      \ 'junegunn/vim-easy-align'   : 0,
      \ 'tpope/vim-abolish'         : 1,
      \ 'tpope/vim-apathy'          : 1,
      \ 'tpope/vim-commentary'      : 0,
      \ 'tpope/vim-endwise'         : 0,
      \ 'tpope/vim-fugitive'        : 1,
      \ 'tpope/vim-repeat'          : 1,
      \ 'tpope/vim-obsession'       : 0,
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
  let g:ale_disable_lsp = 1
  let g:ale_use_neovim_diagnostics_api = 1
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
let g:matchup_delim_noskips = 2

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
"  }}1
