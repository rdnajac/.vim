" $MYVIMRC
scriptencoding utf-8

" Section: settings {{{1
set findfunc=file#find
" general {{{2
set ignorecase
set jumpoptions+=stack
set mouse=a
set report=0
set scrolloff=8
set sessionoptions-=blank sessionoptions-=terminal
set shortmess+=aA "c
set shortmess-=o
set showmatch
set smartcase
set splitbelow splitright splitkeep=screen
set switchbuf+=vsplit " NOTE: minimax wants `usetab`
set timeoutlen=420
set updatetime=999
set virtualedit=block
set whichwrap+=<,>,[,],h,l
set wildignore+=*.o,*.out,*.a,*.so

" indent {{{2
set breakindent
set breakindentopt=list:1 " TODO: from minimax; keep?
set linebreak
set shiftround
set shiftwidth=2 softtabstop=2 " WARN: don't change tabstop!

augroup vimrc_indent
  autocmd!
  " autocmd FileType markdown,tex    setl sw=2 sts=2
  autocmd FileType cpp,cuda,python setl sw=4 sts=4
  autocmd FileType c,sh,zsh        setl sw=8 sts=8
augroup END

" chars {{{ 2
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

" close folds when moving left at beginning of line
nnoremap <expr> h virtcol('.') <= indent('.') + 1 ? 'zc' : 'h'

" save, override, and restore commentstring to get nice folds
xnoremap zf :<C-u>let s=&l:cms \| let &l:cms=' '..s \| '<,'>fold \| let &l:cms=s<CR>

" format {{{2
" one or more special characters (digit, -, +, *), possibly followed by `.` or `)`, whitespace
" default:         `'^\s*\d\+[\]:.)}\t ]\s*'`
set formatlistpat=^\s*[0-9\-\+\*]\+[\.\)]*\s\+

augroup vimrc_format
  autocmd!
  autocmd FileType vim,lua setlocal nowrap formatoptions-=o conceallevel=2
augroup END

" ui {{{2
let &laststatus = has('nvim') ? 3 : 2
set tabline=%!vimline#tabline#()
set cursorline
set number
set signcolumn=number
set termguicolors
" set cursorlineopt = 'screenline,number' TODO: from minimax; keep?

augroup vimrc_ui
  set number

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
" set undo if on nvim, or if on a machine not running nvim
let &undofile = (has('nvim') || !executable('nvim')) ? 1 : &undofile

if !has('nvim')
  call vim#defaults#()
  call vim#sensible#()
  color scheme
else
  " set autocomplete
  set backup
  set backupext=.bak
  set backupdir=~/.local/state/nvim/backup//
  set backupskip+=~/.cache/*
  set cmdheight=0
  set jumpoptions+=view
  set mousescroll=hor:0
  set startofline " default in vim
  set smoothscroll
  set pumblend=0
  set pumborder=rounded
  set pumheight=10
  set winborder=rounded

  " uncomment to disable the default popup menu
  " aunmenu PopUp | autocmd! nvim.popupmenu

  " restart neovim and restore state with Session
  nnoremap <D-r> <Cmd>exe 'mks!' stdpath('state')..'/Session.vim' \| exe 'conf restart sil so' v:this_session<CR>
endif
" }}}1

" Section: autocmds {{{1
augroup vimrc
  au!
  au BufReadPost vimrc call vimrc#setmarks()
  au BufLeave vimrc normal! mV

  " restore cursor position upon reopening files
  au BufWinEnter * exe "silent! normal! g`\"zv"

  " create parent directories when saving files
  au BufWritePre,FileWritePre * if @% !~# '\(://\)' | call mkdir(expand('<afile>:p:h'), 'p') | endif

  " immediately quit the command line window if opened with `q`
  au CmdwinEnter * quit

  " automatically reload files that have been changed outside of Vim
  au FocusGained * if &buftype !=# 'nofile' | checktime | endif

  " close certain buffers with `q`
  au FileType help,qf,nvim-pack nnoremap <buffer> q :lclose<CR><C-W>q

  " don't list certain buffer types (skips C-^)
  au FileType man,netrw,snacks_explorer setlocal nobuflisted

  " automatically resize splits when the window is resized
  au VimResized * let g:tabpagenr = tabpagenr() | tabdo wincmd = | exe 'tabnext' g:tabpagenr

  " catch when vim doesn't terminate properly
  au VimLeave * if v:dying | echo "\nAAAAaaaarrrggghhhh!!!\nExit value is "..v:exiting | endif
augroup END
" }}}1

" Section: commands/config {{{1
for level in keys(g:vim#notify#levels)
  exe printf('command! -nargs=1 -complete=expression %s call vim#notify#%s(eval(<q-args>))',
	\ toupper(strpart(level, 0, 1))..strpart(level, 1), level)
endfor

command! M messages
command! -nargs=* Diff call cmd#diff#(<f-args>)
command! -nargs=1 -complete=customlist,cmd#scp#complete Scp call cmd#scp#(<f-args>)

let g:vimtex_format_enabled = 1
let g:vimtex_mappings_disable = {'n': ['K']}
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

" `https://github.com/neovim/neovim/discussions/38256`
" Usage: $ nvim +Clipboard # or alias pbedit='nvim +Clipboard'
command! Clipboard call edit#clipboard()

if !exists(':hardcopy')
  command! Hardcopy  lua Snacks.terminal.open(([[vim -esNu NONE %s -c 'hardcopy | q!']]):format(vim.api.nvim_buf_get_name(0)))
endif

" set completeopt=menu,preview,longest " see `:h |cmdline-completion|.`
" set completeopt+=preinsert
" More info here: |cmdline-completion|; default: `wildmode=full`
" set wildmode=longest,full    " 1 First press: longest common substring, Second press: full match
set wildmode=longest:full,full " Same as above, but cycle through the first patch ('preinsert'?)
" set wildmode=longest,list    " First press: longest common substring, Second press: list all matches
" set wildmode=noselect:full   " Show 'wildmenu' without selecting, then cycle full matches
" set wildmode=noselect:lastused,full " Same as above, but buffer matches are sorted by time last used

" NOTE: After navigating command-line history, the first call to
" wildtrigger() is a no-op; a second call is needed to start expansion.
" This is to support history navigation in command-line autocompletion.
" autocmd CmdlineChanged [:\/\?] call wildtrigger()

" navigate completion menu with arrow keys
cnoremap <expr> <Down> wildmenumode() ? "\<C-n>" : "\<Down>"
cnoremap <expr> <Up>   wildmenumode() ? "\<C-p>" : "\<Up>"

" autocomplete
" imap / /<C-x><C-f><C-n>
" imap <expr> <Tab> pumvisible() ? <C-y> : <Tab>

nnoremap ?? :verbose set ?<Left>
cnoreabbrev ?? verbose set ?<Left>
cnoreabbrev !! !./%
cnoreabbrev <expr> %% expand('%:p:h')

function! s:singlequote(str)
  return "'"..substitute(copy(a:str), "'", "''", 'g').."'"
endfunction

function! s:cabbrev(lhs, rhs)
  " execute printf( 'cnoreabbrev <expr> %s (getcmdtype() ==# ":" && getcmdline() =~# "%s") ? "%s" : "%s"',
  execute printf('cabbrev <expr> %s (getcmdtype() == ":" && getcmdpos() <= %d) ? %s : %s',
	\ a:lhs, 1+len(a:lhs), s:singlequote(a:rhs), s:singlequote(a:lhs))
endfunction

call s:cabbrev('vv', 'verbose')
call s:cabbrev('vvc', 'verbose cmap')
call s:cabbrev('vvi', 'verbose imap')
call s:cabbrev('vvn', 'verbose nmap')
call s:cabbrev('vvo', 'verbose omap')
call s:cabbrev('vvt', 'verbose tmap')
call s:cabbrev('vvx', 'verbose xmap')
call s:cabbrev('scp', '!scp %')
call s:cabbrev('m', 'Man')
call s:cabbrev('f', 'find')
" }}}1

" Section: keymaps {{{1
let g:mapleader = '\'
let g:maplocalleader = ','

xmap <Space> <leader>

nnoremap <Space> :
nnoremap : ,

nnoremap ` ~
nnoremap ~ `

" when in doubt, pinky out
nnoremap  ciw
nnoremap  <Cmd>lua Snacks.explorer.open({cwd = Snacks.git.get_root()})<CR>
nnoremap  <Cmd>lua Snacks.picker()<CR>
xnoremap  :sort<CR>

xnoremap < <gv
xnoremap > >gv

nnoremap zq <Cmd>call vim#with#savedView('call format#buffer()')<CR>
nnoremap zJ <Plug>(unimpaired-move-down)kJ

" TODO: diff?
" nnoremap dp     dp]c
" nnoremap do     do]c

" `<leader>` {{{2

" debug
nnoremap <leader>da <Cmd>ALEInfo<CR>
nnoremap <leader>db <Cmd>verb se buftype? bufhidden? buflisted? filetype? syntax?<CR>
nnoremap <leader>df <Cmd>verb se foldenable? foldmethod? foldexpr? foldlevel? foldlevelstart? foldminlines?<CR>
nnoremap <leader>ds <Cmd>verb se shell? shellcmdflag? shellpipe? shellquote? shellredir? shellslash? shellxquote?<CR>
if has('nvim')
  nnoremap <leader>di <Cmd>Inspect<CR>
  nnoremap <leader>dI <Cmd>Inspect!<CR>
  nnoremap <leader>dT <Cmd>lua vim.treesitter.inspect_tree(); vim.api.nvim_input('I')<CR>
  nnoremap <leader>dF <Cmd>=vim.filetype.inspect()<CR>
endif

" file
nnoremap <leader>fD <Cmd>Delete!<Bar>bwipeout #<CR>
nnoremap <leader>fT :set ft=<C-R>=&ft<CR><Bar>Info 'ft reloaded!'<CR>
nnoremap <leader>fS <Cmd>call edit#snippets()<CR>
nnoremap <leader>ft <Cmd>call edit#ftplugin()<CR>
nnoremap <leader>fw <Cmd>call format#clean_whitespace()<CR>

" navigation {{{2
nnoremap <BS> :bprevious<CR>
nnoremap <C-BS> g;
nnoremap <C-q> <Cmd>wincmd c<CR>
nnoremap <C-w><C-s> <Cmd>sbprevious<CR>
nnoremap <C-w><C-v> <Cmd>vertical +sbprevious<CR>
" NOTE: S-Tab not detected in all terminals...
" nnoremap <S-Tab>   <Cmd>wincmd w<CR>
" just like tmux!
" nnoremap <C-w>-     <C-w>s
" nnoremap <C-w><Bar> <C-w>v
nnoremap <leader>bD <Cmd>lua Snacks.bufdelete.other()<CR>
nnoremap <leader>bd <Cmd>lua Snacks.bufdelete()<CR>

" window navigation with Shift + h/j/k/l
for [dir, key] in items({'Left':'h', 'Down':'j', 'Up':'k', 'Right':'l'})
  exe $'nnoremap <S-{dir}> <Cmd>wincmd {key}<CR>'
  exe $'tnoremap <S-{dir}> <Cmd>wincmd {key}<CR>'
endfor

" searching and centering {{{3
" make `n` and `N` behave the same way for `?` and `/` searches
" https://github.com/mhinz/vim-galore?tab=readme-ov-file#saner-behavior-of-n-and-n
" NOTE: 'Nn'[v:searchforward] == (v:searchforward ? 'n' : 'N')
nnoremap <expr> n (v:searchforward ? 'n' : 'N')..'zv'
nnoremap <expr> N (v:searchforward ? 'N' : 'n')..'zv'

" tabpages {{{3
nnoremap ]<Tab> <Cmd>tabnext<CR>
nnoremap [<Tab> <Cmd>tabprevious<CR>
nnoremap <leader><Tab><Tab> <Cmd>tabnew<CR>
nnoremap <leader><Tab>d <Cmd>tabclose<CR>
nnoremap <leader><Tab>D <Cmd>tabonly<CR>
nnoremap <leader><Tab>f :<C-U>tabfind<Space>

nnoremap <Bslash>i <Cmd>call edit#($MYVIMRC)<CR>
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

" substitutions {{{2
" https://github.com/kaddkaka/vim_examples?tab=readme-ov-file
" #repeat-last-change-in-all-of-file-global-repeat-similar-to-g
nnoremap g. :%s//<C-R>./g<ESC>
" #replace-only-within-selection
xnoremap s :s/\%V
" similarly, apply normal command to each line in selection
xnoremap n :normal!<Space>

" insert {{{2
" insert chars at EOL {{{3
" nnoremap <Bslash>, mzA,<Esc>;`z
" nnoremap <Bslash>; mzA;<Esc>;`z
" nnoremap <Bslash>. mzA.<Esc>;`z

" insert special chars
inoremap \sec Section:
iabbrev n- –
iabbrev m- —

" insert mode undo breakpoints {{{3
inoremap , ,<C-g>u
inoremap . .<C-g>u
inoremap ; ;<C-g>u

" toggles {{{2
" TODO: play nicely with Snacks.toggle and vim-uninpaired
nnoremap yon :set number!<BAR>redraw!<BAR>set number?<CR>
nnoremap yol :set list!<BAR>set list?<CR>
nnoremap yos :set spell!<BAR>set spell?<CR>
nnoremap yow :set wrap!<BAR>set wrap?<CR>
nnoremap yo~ :set autochdir!<BAR>set autochdir?<CR>
" }}}
" }}}1

" Section: pack {{{1
packadd! cfilter
if has('nvim')
  packadd! nvim.difftool
  packadd! nvim.tohtml
  packadd! nvim.undotree
else
  packadd! comment
  packadd! editorconfig
  packadd! hlyank
endif

call plug#begin()
Plug 'alker0/chezmoi.vim'
Plug 'dense-analysis/ale'
Plug 'lervag/vimtex'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-capslock'
Plug 'tpope/vim-characterize'
" Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rsi'
Plug 'tpope/vim-rhubarb'
Plug 'tpope/vim-scriptease'
" Plug 'tpope/vim-sensible'
Plug 'tpope/vim-speeddating'
Plug 'tpope/vim-tbone'
Plug 'tpope/vim-unimpaired'
" Plug 'tpope/vim-vinegar'
" Plug 'bullets-vim/bullets.vim'
" Plug 'dstein64/vim-startuptime'
" Plug 'vuciv/golf'
if !has('nvim')
  " Plug 'andymass/vim-matchup'
  Plug 'github/copilot.vim'
  Plug 'junegunn/vim-easy-align'
  Plug 'justinmk/vim-dirvish'
  Plug 'wellle/targets.vim'
  Plug 'wellle/tmux-complete.vim'
  Plug 'AndrewRadev/dsf.vim'
  Plug 'AndrewRadev/splitjoin.vim'
  Plug 'Konfekt/FastFold'
else
  Plug 'nvim-mini/mini.nvim'
  Plug 'neovim/nvim-lspconfig'
  " Plug 'b0o/SchemaStore.nvim'
  Plug 'chrisgrieser/nvim-scissors'
  " Plug 'j-hui/fidget.nvim'
  " Plug 'saxon1964/neovim-tips'
endif
Plug 'tpope/vim-dadbod'
Plug 'kristijanhusak/vim-dadbod-ui'
Plug 'kristijanhusak/vim-dadbod-completion'
call plug#end()
" }}}1

" vim: fdm=marker fdl=1
