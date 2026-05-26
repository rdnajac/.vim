augroup vimrc " {{{
  if !has('nvim')
    call vimrc#init()
  else
    " set autocomplete
    set backup
    set backupext=.bak
    set backupdir=~/.local/state/nvim/backup//
    set backupskip+=~/.cache/*
    " set cmdheight=0
    set jumpoptions+=view
    set mousescroll=hor:0
    set startofline " default in vim
    set smoothscroll
    set pumblend=0
    set pumborder=rounded
    set pumheight=10
    set winborder=rounded
    " set statusline=%{%v:lua.require'nvim'.statusline()%}
    set statusline=%{%v:lua.nv.statusline()%}
    set     winbar=%{%v:lua.nv.winbar()%}
  endif

  let &undofile = (has('nvim') || !executable('nvim')) ? 1 : &undofile

  set findfunc=file#find
  set ignorecase
  set jumpoptions+=stack
  set mouse=a
  set report=0
  set scrolloff=8
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

  au!
  " au BufReadPost vimrc call vimrc#setmarks()
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
  au FileType help,qf,nvim-pack nnoremap <buffer> q <Cmd>wincmd c<CR>

  " don't list certain buffer types (skips C-^)
  au FileType man,netrw,snacks_explorer setlocal nobuflisted

  " automatically resize splits when the window is resized
  au VimResized * let s:tabpagenr = tabpagenr() | tabdo wincmd = | exe 'tabnext' s:tabpagenr

  " catch when vim doesn't terminate properly
  au VimLeave * if v:dying | echo "\nAAAAaaaarrrggghhhh!!!\nExit value is "..v:exiting | endif
augroup END " }}}
augroup vimrc.fold " {{{
  set foldlevel=99
  " set foldlevelstart=1
  " set foldminlines=3
  set foldopen+=insert,jump
  " set foldmethod=marker

  " close folds when moving left at beginning of line
  nnoremap <expr> h virtcol('.') <= indent('.') + 1 ? 'zc' : 'h'

  " save, override, and restore commentstring to get nice folds
  xnoremap zf :<C-u>let s=&l:cms \| let &l:cms=' '..s \| '<,'>fold \| let &l:cms=s<CR>

  autocmd!
  " autocmd FileType vim,lua setlocal
augroup END " }}}
augroup vimrc.format " {{{
  " one or more special characters (digit, -, +, *), possibly followed by `.` or `)`, whitespace
  " default:         `'^\s*\d\+[\]:.)}\t ]\s*'`
  set formatlistpat=^\s*[0-9\-\+\*]\+[\.\)]*\s\+
  autocmd!
  autocmd FileType vim,lua setlocal nowrap formatoptions-=o conceallevel=2
augroup END " }}}
augroup vimrc.indent " {{{
  set breakindent
  set breakindentopt=list:1 " TODO: from minimax; keep?
  set linebreak
  set shiftround
  set shiftwidth=2 softtabstop=2 " WARN: don't change tabstop!
  autocmd!
  " autocmd FileType markdown,tex    setl sw=2 sts=2
  autocmd FileType cpp,cuda,python setl sw=4 sts=4
  autocmd FileType c,sh,zsh        setl sw=8 sts=8
augroup END " }}}
augroup vimrc.keywordprg " {{{
  " preserve the original K mapping
  " NOTE: overridden in some filetypes below
  nnoremap <leader>k <Cmd>normal! K<CR>

  command! -nargs=* MyMan call s:mykeywordprg(<f-args>)
  function! s:mykeywordprg(...) abort
    if !empty(b:manpage)
      let keyword = a:0 ? a:1 : expand('<cword>')
      " Info keyword
      execute 'Man' b:manpage
      call search(keyword)
    endif
  endfunction

  function! s:setup(...) abort
    let b:manpage = a:0 ? a:1 : &filetype
    setlocal keywordprg=:MyMan
    setlocal iskeyword+=-
  endfunction
  autocmd!
  " au BufRead,BufNewFile *alacritty.*ml call s:setup('5 alacritty')
  au FileType ghostty,kitty,tmux call s:setup()
  au FileType sshconfig call s:setup('ssh')
  au FileType gitconfig,gitconfig.chezmoitmpl call s:setup('git-config(1)')
  au FileType lua setlocal keywordprg=:help iskeyword+=-
  au FileType sh  setlocal keywordprg=:Man  iskeyword-=_
  au FileType tex nnoremap <silent><buffer> <leader>K <Plug>(vimtex-doc-package)
  au FileType vim nnoremap <silent><buffer> <leader>K <Plug>ScripteaseHelp
augroup END " }}}
augroup vimrc.sesh " {{{
set sessionoptions-=blank
set sessionoptions-=folds
set sessionoptions-=terminal

if has('nvim')
  " au SessionLoadPre
  " au SessionLoadPost
  " au SessionWritePost

  function s:restart() abort
    execute 'mksession!' stdpath('state')..'/Session.vim'
    execute 'confirm restart silent source' v:this_session
  endfunction

  command! Restart call s:restart()
  nnoremap <D-r> <Cmd>Restart<CR>
endif
augroup END " }}}
augroup vimrc.term " {{{
tnoremap <expr> <C-R> '<C-\><C-N>"'.nr2char(getchar()).'pi'
  autocmd BufEnter term://*:R\ * startinsert
  autocmd BufEnter term://*/copilot startinsert
  if has('nvim') " TODO: move to .lua
    autocmd TermOpen * let g:last_term_ch = &channel
    autocmd TermOpen * let g:last_term_buf = bufnr('%')
  endif
augroup END " }}}
augroup vimrc.ui  " {{{
  set cursorline
  set list
  set number
  set signcolumn=number
  " set termguicolors
  let &l:laststatus = has('nvim') ? 3 : 2
  set tabline=%!vimline#tabline#()
  set title

  autocmd!
  " no cursorline in insert mode
  au InsertLeave,WinEnter * if exists('w:had_cul') | setl cul | unlet w:had_cul | endif
  au InsertEnter,WinLeave * if &cul | let w:had_cul = 1 | setl nocul | endif

  " hide the statusline while in command mode
  " au CmdlineEnter * if &ls != 0 | let g:last_ls = &ls | set ls=0 |endif
" au CmdlineLeave * if exists('g:last_ls') | let &ls = g:last_ls | unlet g:last_ls | endif

  " relative numbers in visual mode only if number is already set
  au ModeChanged [vV\x16]*:* if &nu| let &l:rnu = mode() =~# '^[vV\x16]' | endif
  au ModeChanged *:[vV\x16]* if &nu| let &l:rnu = mode() =~# '^[vV\x16]' | endif
  au WinEnter,WinLeave *     if &nu| let &l:rnu = mode() =~# '^[vV\x16]' | endif
augroup END " }}}
augroup vimrc.yank " {{{
  " yank/delete everything
  nnoremap yY <Cmd>%y<CR>
  nnoremap dD <Cmd>%d<CR>

  " delete/paste without yanking
  nnoremap dy "_dd
  vnoremap p "_dP
  vnoremap <leader>c "_c
  vnoremap <leader>d "_d

  " `clipboard=autoselect` is not implemented yet
  " https://github.com/neovim/neovim/issues/2325.
  " vnoremap <LeftRelease>   "*ygv
  " vnoremap <2-LeftRelease> "*ygv

  " yank path current file path, with and without line number
  nnoremap yp <Cmd>let @*=expand('%:p:~')<CR>
  nnoremap yP <Cmd>let @*=printf('%s:%d', expand('%:p:~'), line('.'))<CR>
  cnoremap <M-y> <Cmd>let @*=getcmdline()<CR>

  " change macro
  nnoremap cm :<C-u><C-r><C-r>="let @q = " . string(getreg('q'))<CR>
  nnoremap cM :<C-u><C-r><C-r>="let @". v:register ." = ". string(getreg(v:register))<CR><Left>

  function s:set_clipboard() abort
    if !has('nvim')
      set clipboard=unnamed
    elseif !exists('$SSH_TTY')
      " don't set clipboard over ssh
      set clipboard=unnamedplus
    endif
  endfunction

  function s:fallback() abort
    if empty(&clipboard)
      " map default yank to system clipboard
      nnoremap <expr> y v:register == '"' ? '"+y' : 'y'
      vnoremap <expr> y v:register == '"' ? '"+y' : 'y'
      " copy the last yanked text to the system clipboard
      silent let @+ = getreg('"')
    endif
  endfunction

  function! s:yankring() abort
    if v:event.operator ==# 'y'
      " call map(range(9, 1, -1), {_, i -> setreg(string(i), getreg(string(i-1)))})
      for i in range(9, 1, -1)
	call setreg(string(i), getreg(string(i - 1)))
      endfor
    endif
  endfunction

  autocmd!
  autocmd TextYankPost * call s:yankring()
  " Setup unnamedplus clipboard on first yank if the system clipboard is not not already setup
  autocmd TextYankPost * ++once call s:fallback()
  if has('nvim')
    autocmd TextYankPost * silent! lua vim.hl.on_yank()
    autocmd UIEnter * call s:set_clipboard()
  endif
augroup END " }}}

" Section: commands {{{1

command! -nargs=* Diff call cmd#diff#(<f-args>)
command! -nargs=1 -complete=customlist,cmd#scp#complete Scp call cmd#scp#(<f-args>)

" `https://github.com/neovim/neovim/discussions/38256`
" Usage: $ nvim +Clipboard # or alias pbedit='nvim +Clipboard'
command! Clipboard call edit#clipboard()

if !exists(':hardcopy')
  command! Hardcopy  lua Snacks.terminal.open(([[vim -esNu NONE %s -c 'hardcopy | q!']]):format(vim.api.nvim_buf_get_name(0)))
endif

let g:vimtex_format_enabled = 1
let g:vimtex_mappings_disable = {'n': ['K']}
let g:vimtex_quickfix_method = executable('pplatex') ? 'pplatex' : 'latexlog'

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
" maybe check getcmdline() =~# "%s"
function! s:cabbrev(lhs, rhs)
  execute printf(
	\ 'cabbrev <expr> %s (getcmdtype() == ":" && getcmdpos() <= %d) ? %s : %s',
	\ a:lhs, 1+len(a:lhs), s:singlequote(a:rhs), s:singlequote(a:lhs))
endfunction

call s:cabbrev('f', 'find')
call s:cabbrev('dd', 'echom')
call s:cabbrev('vv', 'verbose')
call s:cabbrev('vc', 'verbose cmap')
call s:cabbrev('vi', 'verbose imap')
call s:cabbrev('vn', 'verbose nmap')
call s:cabbrev('vo', 'verbose omap')
call s:cabbrev('vt', 'verbose tmap')
call s:cabbrev('vx', 'verbose xmap')
if has('nvim')
  call s:cabbrev('man', 'Man')
  call s:cabbrev('S', 'lua Snacks.picker')
endif
" }}}1

" Section: keymaps {{{1
nnoremap ` ~
nnoremap ~ `
" when in doubt, pinky out
nnoremap <C-c> ciw
nnoremap <C-e> <Cmd>lua Snacks.explorer.open({cwd = Snacks.git.get_root()})<CR>
nnoremap <C-f> <Cmd>lua Snacks.picker()<CR>
xnoremap <C-s> :sort<CR>
xnoremap < <gv
xnoremap > >gv

nnoremap zq <Cmd>call vim#with#savedView('call format#buffer()')<CR>
nnoremap ZF <Cmd>echom 'formatting...'<Bar>ALEFix<CR>
nnoremap ZW <Cmd>echom 'formatting and saving...'<Bar>ALEFix<Bar>write!<CR>
nnoremap zJ <Plug>(unimpaired-move-down)kJ

" TODO: diff?
" nnoremap dp dp']c
" nnoremap do do]c

" `<leader>` {{{2
let g:mapleader = ','
let g:maplocalleader = '/'
nnoremap <Space> :
nnoremap : ,
xmap <Space> <leader>

" debug/diagnostic
nnoremap <leader>da <Cmd>ALEInfo<CR>
nnoremap <leader>db <Cmd>verb se buftype? bufhidden? buflisted? filetype? syntax?<CR>
nnoremap <leader>df <Cmd>verb se foldenable? foldmethod? foldexpr? foldlevel? foldlevelstart? foldminlines?<CR>
nnoremap <leader>ds <Cmd>verb se shell? shellcmdflag? shellpipe? shellquote? shellredir? shellslash? shellxquote?<CR>
if has('nvim')
  nnoremap <leader>di <Cmd>Inspect<CR>
  nnoremap <leader>dI <Cmd>Inspect!<CR>
  nnoremap <leader>dT <Cmd>lua vim.treesitter.inspect_tree(); vim.api.nvim_input('I')<CR>
  nnoremap <leader>dF <Cmd>=vim.filetype.inspect()<CR>
  nnoremap <leader>dq <Cmd>lua vim.diagnostic.setloclist()<CR>
  nnoremap <leader>dQ <Cmd>lua vim.diagnostic.setqflist()<CR>
  nnoremap <leader>dR <Cmd>=require('r.config').get_config()<CR>
endif
" file
nnoremap <leader>fD <Cmd>Delete!<Bar>bwipeout #<CR>
nnoremap <leader>fT :set ft=<C-R>=&ft<CR><Bar>Info 'ft reloaded!'<CR>
nnoremap <leader>fS <Cmd>call edit#snippets()<CR>
nnoremap <leader>ft <Cmd>call edit#ftplugin()<CR>
nnoremap <leader>fw <Cmd>call format#clean_whitespace()<CR>

nnoremap <leader>m <Cmd>messages<CR>
nnoremap <leader>p g<

" navigation {{{2
nnoremap H ^
nnoremap L $
nnoremap <BS> :bprevious<CR>
nnoremap <C-BS> g;
nnoremap <C-q> <Cmd>wincmd c<CR>
nnoremap <C-w><C-s> <Cmd>sbprevious<CR>
nnoremap <C-w><C-v> :<C-u>vsplit #<CR>
" nnoremap <C-w>-     <C-w>s
" nnoremap <C-w><Bar> <C-w>v
" nnoremap <S-Tab>    <Cmd>wincmd w<CR>
" NOTE: S-Tab not detected in all terminals...
" window navigation with Shift + h/j/k/l {{{3
for [dir, key] in items({'Left':'h', 'Down':'j', 'Up':'k', 'Right':'l'})
  exe $'nnoremap <S-{dir}> <Cmd>wincmd {key}<CR>'
  exe $'tnoremap <S-{dir}> <Cmd>wincmd {key}<CR>'
endfor
" }}}3
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
nnoremap <Bslash>0 <Cmd>call edit#readme()<CR>
" }}}3
" editing {{{2
" change/delete current word
nnoremap c*  *``cgn
nnoremap c#  *``cgN
nnoremap d*  *``dgn
nnoremap d#  *``dgN

" https://github.com/kaddkaka/vim_examples?tab=readme-ov-file
" #repeat-last-change-in-all-of-file-global-repeat-similar-to-g
nnoremap g. :%s//<C-R>./g<ESC>
" #replace-only-within-selection
xnoremap s :s/\%V
" similarly, apply normal command to each line in selection
xnoremap n :normal!<Space>

" insert chars at EOL
" nnoremap <Bslash>, mzA,<Esc>;`z
" nnoremap <Bslash>; mzA;<Esc>;`z
" nnoremap <Bslash>. mzA.<Esc>;`z

" undo breakpoints
inoremap , ,<C-g>u
inoremap . .<C-g>u
inoremap ; ;<C-g>u
" }}}2
nmap gcap gcip
" }}}1

" Section: plugins {{{1
packadd! cfilter
if !has('nvim')
  packadd! comment
  packadd! editorconfig
  packadd! hlyank
else
  packadd! nvim.difftool
  packadd! nvim.tohtml
  packadd! nvim.undotree
  packadd! munchies.nvim
  " packadd! rd.nvim
endif

call plug#begin()
Plug 'alker0/chezmoi.vim'
Plug 'dense-analysis/ale'
Plug 'dstein64/vim-startuptime'
Plug 'lervag/vimtex'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-capslock'
Plug 'tpope/vim-characterize'
Plug 'tpope/vim-dadbod'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-rhubarb'
Plug 'tpope/vim-rsi'
Plug 'tpope/vim-scriptease'
" Plug 'tpope/vim-sensible'
Plug 'tpope/vim-speeddating'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-tbone'
Plug 'tpope/vim-unimpaired'
" Plug 'tpope/vim-vinegar'
Plug 'justinmk/vim-dirvish'
" Plug 'bullets-vim/bullets.vim'
" Plug 'romainl/vim-qf.git'
" Plug 'vuciv/golf'
Plug 'AndrewRadev/splitjoin.vim'
if !has('nvim')
  Plug 'AndrewRadev/dsf.vim'
  Plug 'Konfekt/FastFold'
  " Plug 'andymass/vim-matchup'
  Plug 'junegunn/vim-easy-align'
  Plug 'wellle/targets.vim'
  Plug 'wellle/tmux-complete.vim'
else
  Plug 'chrisgrieser/nvim-scissors'
  Plug 'folke/snacks.nvim'
  Plug 'folke/tokyonight.nvim'
  Plug 'folke/which-key.nvim'
  Plug 'nvim-mini/mini.nvim'
  Plug 'neovim/nvim-lspconfig'
  " Plug 'b0o/SchemaStore.nvim'
endif
Plug 'github/copilot.vim'
Plug 'iamcco/markdown-preview.nvim'
call plug#end()
color scheme
" }}}1
" vim: foldmethod=marker foldlevel=0
