" set autocomplete
set exrc
augroup vimrc
  au!
  call vimrc#init()
  set ignorecase
  set jumpoptions+=stack
  set mouse=a
  set report=0
  set scrolloff=8
  set shortmess+=aA "c
  set shortmess-=o
  set showmatch
  set smartcase
  set timeoutlen=420
  set updatetime=999
  set virtualedit=block
  set whichwrap+=<,>,[,],h,l
  set wildignore+=*.o,*.out,*.a,*.so

  au BufLeave    vimrc normal! mV
  au BufReadPost vimrc call vimrc#setmarks()
  " automatically resize splits when the window is resized
  au VimResized * let s:tabpagenr = tabpagenr() | tabdo wincmd = | exe 'tabnext' s:tabpagenr
  " catch when vim doesn't terminate properly
  au VimLeave * if v:dying | echo "\nAAAAaaaarrrggghhhh!!!\nExit value is "..v:exiting | endif
augroup END
augroup vimrc.buffers
  au!
  set splitbelow
  set splitright
  set splitkeep=screen
  set switchbuf+=vsplit " NOTE: minimax wants `usetab`
  " restore cursor position upon reopening files
  au BufWinEnter * exe "silent! normal! g`\"zv"
  " automatically reload files that have been changed outside of Vim
  au FocusGained * if &buftype !=# 'nofile' | checktime | endif
  " close certain buffers with `q`
  au FileType help,qf,nvim-pack nnoremap <buffer> q <Cmd>wincmd c<CR>
  " don't list certain buffer types (skips `<C-^>`)
  au FileType man,netrw,snacks_explorer setlocal nobuflisted
augroup END
augroup vimrc.commands
  au!
  command! -nargs=* Diff call cmd#diff#(<f-args>)
  command! -nargs=1 -complete=customlist,cmd#scp#complete Scp call cmd#scp#(<f-args>)
  " `https://github.com/neovim/neovim/discussions/38256`
  " Usage: $`nvim +Clipboard` or `alias pbedit='nvim +Clipboard'`
  command! Clipboard call cmd#clipboard#()

  if !exists(':hardcopy')
    " TODO: use `jobstart` to avoid the Snacks dependency
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

  nnoremap ?? :verbose set ?<Left>
  cnoreabbrev ?? verbose set ?<Left>
  cnoreabbrev !! !./%
  cnoreabbrev <expr> %% expand('%:p:h')

  call cmd#abbrev('f', 'find')
  call cmd#abbrev('dd', 'echom')
  call cmd#abbrev('vv', 'verbose')
  call cmd#abbrev('vc', 'verbose cmap')
  call cmd#abbrev('vi', 'verbose imap')
  call cmd#abbrev('vn', 'verbose nmap')
  call cmd#abbrev('vo', 'verbose omap')
  call cmd#abbrev('vt', 'verbose tmap')
  call cmd#abbrev('vx', 'verbose xmap')
  if has('nvim')
    call cmd#abbrev('man', 'Man')
    call cmd#abbrev('S', 'lua Snacks.picker')
  endif
  " immediately quit the command line window if opened
  autocmd CmdwinEnter * quit
augroup END
augroup vimrc.dirs
  au!
  set nocdhome " default on neovim on unix, off on Windows or vim
  let s:cd_maps = {
	\ 'b': '%:p:h',
	\ 'g': 'git#root()',
	\ '-': '-',
	\ }
  for [k, v] in items(s:cd_maps)
    execute $'nnoremap cd{k} <Cmd>cd {v} \| verbose pwd <CR>'
  endfor

  let s:dirs = {
	\ '~': $HOME,
	\ 'B': &backupdir,
	\ 'c': g:stdpath#config,
	\ 'C': g:stdpath#cache,
	\ 'd': g:stdpath#data,
	\ 'G': '~/GitHub/',
	\ 'N': '~/GitHub/neovim/',
	\ 'p': g:plug#home,
	\ 'P': $PACKDIR,
	\ 'v': $VIMRUNTIME..'/lua/vim',
	\ 'V': $VIMRUNTIME,
	\ 's': g:stdpath#state,
	\ '.': '~/.local/share/chezmoi/'
	\ }
  for [k, v] in items(s:dirs)
    execute $'nnoremap cd{k} <Cmd>edit {v}<CR>'
  endfor

  if has('nvim')
    " autocmd TermRequest * call term#print_request()
    autocmd TermRequest * call term#handleOSC7()
    " autocmd DirChanged * call chansend(v:stderr, printf("\033]7;file://%s\033\\", getcwd()))
  endif
augroup END
augroup vimrc.files
  au!
  " create parent directories when saving files
  au BufWritePre,FileWritePre * if @% !~# '\(://\)' | call mkdir(expand('<afile>:p:h'), 'p') | endif

  set findfunc=file#find
  if has('nvim')
    set backup
    set backupext=.bak
    set backupdir=~/.local/state/nvim/backup//
    set backupskip+=~/.cache/*
  endif
  let &undofile = (has('nvim') || !executable('nvim')) ? 1 : &undofile
augroup END
augroup vimrc.fold
  au!
  set foldlevel=99
  " set foldlevelstart=1
  " set foldminlines=3
  set foldopen+=insert,jump
  " set foldmethod=marker

  " close folds when moving left at beginning of line
  nnoremap <expr> h virtcol('.') <= indent('.') + 1 ? 'zc' : 'h'

  " save, override, and restore commentstring to get nice folds
  xnoremap zf :<C-u>let s=&l:cms \| let &l:cms=' '..s \| '<,'>fold \| let &l:cms=s<CR>

  " autocmd FileType vim,lua setlocal
  if has('nvim')
    " use treesitter folding by default for some filetypes
    autocmd FileType markdown,r,rmd,quarto setl fdm=expr fde=v:lua.vim.treesitter.foldexpr()
  endif
augroup END
augroup vimrc.format
  au!
  nnoremap zq <Cmd>call vim#with#savedView('call format#buffer()')<CR>
  nnoremap ZF <Cmd>echom 'formatting...'<Bar>ALEFix<CR>
  nnoremap ZW <Cmd>echom 'formatting and saving...'<Bar>ALEFix<Bar>write!<CR>
  " one or more special characters (digit, -, +, *), possibly followed by `.` or `)`, whitespace
  " default:         `'^\s*\d\+[\]:.)}\t ]\s*'`
  set formatlistpat=^\s*[0-9\-\+\*]\+[\.\)]*\s\+
  autocmd FileType vim,lua setlocal nowrap formatoptions-=o conceallevel=2
augroup END
augroup vimrc.indent
  au!
  set breakindent
  set breakindentopt=list:1 " TODO: from minimax; keep?
  set linebreak
  set shiftround
  set shiftwidth=2 softtabstop=2 " WARN: don't change tabstop!
  " autocmd FileType markdown,tex    setl sw=2 sts=2
  autocmd FileType cpp,cuda,python setl sw=4 sts=4
  autocmd FileType c,sh,zsh        setl sw=8 sts=8
augroup END
augroup vimrc.keywordprg
  au!
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
  " au BufRead,BufNewFile *alacritty.*ml call s:setup('5 alacritty')
  au FileType ghostty,kitty,tmux call s:setup()
  au FileType sshconfig call s:setup('ssh')
  au FileType gitconfig,gitconfig.chezmoitmpl call s:setup('git-config(1)')
  au FileType lua setlocal keywordprg=:help iskeyword+=-
  au FileType sh  setlocal keywordprg=:Man  iskeyword-=_
  au FileType tex nnoremap <silent><buffer> <leader>K <Plug>(vimtex-doc-package)
  au FileType vim nnoremap <silent><buffer> K <Plug>ScripteaseHelp
augroup END
augroup vimrc.navigation
  au!
if has('nvim')
  " settings with new options
  set jumpoptions+=view
  " nvim-specific settings
  set mousescroll=hor:0
  set smoothscroll
  " default changed from vim
  set startofline
endif
augroup END
augroup vimrc.register
  au!
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

  " set clipboard on first yank if not already setup
  autocmd TextYankPost * ++once call register#clipboard_fallback()
  autocmd TextYankPost * call register#yankring()
  if has('nvim')
    autocmd TextPutPost  * silent! lua vim.hl.hl_op()
    autocmd TextYankPost * silent! lua vim.hl.hl_op()
    autocmd UIEnter * call register#set_clipboard()
  endif
augroup END
augroup vimrc.sesh
  au!
  " default `blank,buffers,curdir,folds,help,tabpages,winsize,terminal`
  set sessionoptions-=blank
  set sessionoptions-=curdir
  set sessionoptions-=terminal
  if has('nvim')
    nnoremap <D-r> <Cmd>exe 'mks!' stdpath('data')..'/Session.vim' \|
	  \ exe 'confirm restart source' v:this_session<CR>
    " au SessionLoadPre   * echom '[SessionLoadPre] this session: '..v:this_session
    " au SessionLoadPost  * silent! lua vim.fs.rm(vim.v.this_session)
    au SessionWritePost * echom '[SessionWritePost] this session: '..v:this_session
  endif
augroup END
augroup vimrc.term
  au!
  tnoremap <expr> <C-R> '<C-\><C-N>"'.nr2char(getchar()).'pi'
  if has('nvim')
    autocmd TermOpen * let g:last_term_ch = &channel
    autocmd TermOpen * let g:last_term_buf = bufnr('%')
  endif
augroup END
augroup vimrc.ui
  au!
  set cursorline
  set list
  set number
  set signcolumn=number
  set tabline=%!vimline#tabline#()
  " set termguicolors
  set title
  if has('nvim')
    set pumheight=10
    set pumblend=0
    set pumborder=rounded
    set winborder=rounded
    " vint: -ProhibitAbbreviationOption
    set stl=%{%v:lua.nv.status()%}
    set wbr=%{%v:lua.nv.winbar()%}
    " vint: +ProhibitAbbreviationOption
  endif
  let &l:cmdheight = has('nvim') ? 0 : 1
  let &l:laststatus = has('nvim') ? 3 : 2

  " no cursorline in insert mode
  au InsertLeave,WinEnter * if exists('w:had_cul') | setl cul | unlet w:had_cul | endif
  au InsertEnter,WinLeave * if &cul | let w:had_cul = 1 | setl nocul | endif

  " relative numbers in visual mode only if number is already set
  au ModeChanged [vV\x16]*:* if &nu| let &l:rnu = mode() =~# '^[vV\x16]' | endif
  au ModeChanged *:[vV\x16]* if &nu| let &l:rnu = mode() =~# '^[vV\x16]' | endif
  au WinEnter,WinLeave *     if &nu| let &l:rnu = mode() =~# '^[vV\x16]' | endif

  " hide the statusline while in command mode
  " au CmdlineEnter * if &ls != 0 | let g:last_ls = &ls | set ls=0 |endif
" au CmdlineLeave * if exists('g:last_ls') | let &ls = g:last_ls | unlet g:last_ls | endif
augroup END

" Section: keymaps {{{1
let g:mapleader = ','
let g:maplocalleader = '/'
nnoremap <Space> :
nnoremap : ,
xmap <Space> <leader>
" prefer `'` for marks
nnoremap ` ~
nnoremap ~ `
" when in doubt, pinky out
nnoremap <C-c> ciw
nnoremap <C-e> <Cmd>lua Snacks.explorer.open({cwd = Snacks.git.get_root()})<CR>
nnoremap - <Cmd>lua Snacks.explorer.reveal()<CR>
nnoremap <C-f> <Cmd>lua Snacks.picker()<CR>
xnoremap <C-s> :sort<CR>
xnoremap < <gv
xnoremap > >gv
nnoremap zJ <Plug>(unimpaired-move-down)kJ

" TODO: diff?
" nnoremap dp dp']c
" nnoremap do do]c

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

" TODO: function and user getchar
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
  " bundled
  packadd! nvim.difftool
  packadd! nvim.tohtml
  packadd! nvim.undotree
  packadd! rd.nvim
endif
packadd! vim-symbiote

call plug#begin()
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
" Plug 'justinmk/vim-dirvish'
" Plug 'bullets-vim/bullets.vim'
" Plug 'romainl/vim-qf.git'
" Plug 'vuciv/golf'
Plug 'AndrewRadev/splitjoin.vim'
if !has('nvim')
  Plug 'AndrewRadev/dsf.vim'
  Plug 'Konfekt/FastFold'
  " Plug 'andymass/vim-matchup'
  Plug 'github/copilot.vim'
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
Plug 'iamcco/markdown-preview.nvim'
call plug#end()
" }}}1
color scheme
" vim: foldmethod=marker foldlevel=0 foldmarker=augroup\ vimrc,END
