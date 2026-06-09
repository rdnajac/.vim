" set autocomplete
augroup vimrc.autocmds
  au!
  set timeoutlen=420
  set ttimeoutlen=69
  set report=0
  set shortmess+=aA "c
  set shortmess-=o
  call vimrc#init()
  au BufLeave vimrc normal! mV
  au BufWrite vimrc call vimrc#setmarks()
  " load the colorscheme just before loading the ui
  au VimEnter * color scheme
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
  " automatically reload files that have been changed outside of Vim
  au FocusGained * if &buftype !=# 'nofile' | checktime | endif
  " close certain buffers with `q`
  au FileType help,qf,nvim-pack nnoremap <buffer> q <Cmd>wincmd c<CR>
  " don't list certain buffer types (skips `<C-^>`)
  au FileType man,netrw,snacks_explorer setlocal nobuflisted
augroup END
augroup vimrc.command/completion
  au!
  " default `completeopt=menu,popup`; also see `:h |ins-completion|`
  " set completeopt=menu,preview,longest
  " set completeopt+=preinsert

  " see `:h |cmdline-completion|`, default wildmode=full
  " set wildmode=longest,full    " 1 First press: longest common substring, Second press: full match
  set wildmode=longest:full,full " Same as above, but cycle through the first patch ('preinsert'?)
  " set wildmode=longest,list    " First press: longest common substring, Second press: list all matches
  " set wildmode=noselect:full   " Show 'wildmenu' without selecting, then cycle full matches
  " set wildmode=noselect:lastused,full " Same as above, but buffer matches are sorted by time last used

  " NOTE: After navigating command-line history, the first call to
  " `wildtrigger()` is a no-op; a second call is needed to start expansion.
  " This is to support history navigation in command-line autocompletion.
  " autocmd CmdlineChanged [:\/\?] call wildtrigger()

  " navigate completion menu with arrow keys
  cnoremap <expr> <Down> wildmenumode() ? "\<C-n>" : "\<Down>"
  cnoremap <expr> <Up>   wildmenumode() ? "\<C-p>" : "\<Up>"
  " cnoreabbrev <expr> %% expand('%:p:h')
  call cmd#abbrev('f', 'find')
  call cmd#abbrev('??', 'verbose set ?<Left>')
  call cmd#abbrev('dd', 'echom')
  call cmd#abbrev('vv', 'verbose')
  call cmd#abbrev('vm', 'verbose map')
  call cmd#abbrev('ab', 'verbose ab')
  if has('nvim')
    call cmd#abbrev('man', 'Man')
    call cmd#abbrev('open', 'Open')
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
  if has('nvim')
    " autocmd DirChanged * call chansend(v:stderr, printf("\033]7;file://%s\033\\", getcwd()))
  endif
augroup END
augroup vimrc.edit
  nnoremap cdB <Cmd>exe 'edit' &backupdir<CR>
  nnoremap cdc <Cmd>exe 'edit' g:stdpath#config<CR>
  nnoremap cdC <Cmd>exe 'edit' g:stdpath#cache<CR>
  nnoremap cdd <Cmd>exe 'edit' g:stdpath#data<CR>
  nnoremap cds <Cmd>exe 'edit' g:stdpath#state<CR>
  nnoremap cdG <Cmd>edit ~/GitHub/<CR>
  nnoremap cdN <Cmd>edit ~/GitHub/neovim/<CR>
  nnoremap cdp <Cmd>edit $PACKDIR<CR>
  nnoremap cdv <Cmd>edit $VIMRUNTIME/lua/vim<CR>
  nnoremap cdV <Cmd>edit $VIMRUNTIME<CR>
  nnoremap cd~ <Cmd>edit $HOME<CR>
  nnoremap cd. <Cmd>edit ~/.local/share/chezmoi/<CR>
augroup END
augroup vimrc.fold/format
  au!
  autocmd FileType vim,lua setlocal nowrap formatoptions-=o conceallevel=2
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
  " one or more special characters (digit, -, +, *), possibly followed by `.` or `)`, whitespace
  " default:         `'^\s*\d\+[\]:.)}\t ]\s*'`
  set formatlistpat=^\s*[0-9\-\+\*]\+[\.\)]*\s\+
augroup END
augroup vimrc.hjkl
  call jk#setup_escape_mappings() " TODO: use <C-c>
  nnoremap H ^
  nnoremap L $
  " WARN: `h` and `l` not recommended per `:h 'whichwrap'`
  set whichwrap+=<,>,[,],h,l
  if has('nvim')
    set startofline " default changed from vim
    lua vim.keymap.set({ 'n', 'x' }, { 'j', '<Down>' }, [[v:count ? 'j' : 'gj']], { expr = true, remap = true })
    lua vim.keymap.set({ 'n', 'x' }, { 'k', '<Up>'   }, [[v:count ? 'k' : 'gk']], { expr = true, remap = true })
  else
    " handle wrapped lines better by preferring `gj` and `gk`
    let s:keys = [ 'j', 'k' , '<Down>', '<Up>']
    for [i, key] in items(s:keys)
      let dir = s:keys[i % 2] " limit dir to only j/k
      execute printf("nnoremap <expr> %s (v:count ? '' : 'g')..%s", key, dir)
      execute printf("xnoremap <expr> %s (v:count ? '' : 'g')..%s", key, dir)
    endfor
    unlet s:keys
  endif
  " NOTE: S-Tab not detected in all terminals...
  " window navigation with Shift + h/j/k/l
  for [dir, key] in items({'Left':'h', 'Down':'j', 'Up':'k', 'Right':'l'})
    exe $'nnoremap <S-{dir}> <Cmd>wincmd {key}<CR>'
    exe $'tnoremap <S-{dir}> <Cmd>wincmd {key}<CR>'
  endfor
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
  autocmd FileType quarto          setl noai
augroup END
augroup vimrc.keywordprg
  au!
  " preserve the original K mapping
  " NOTE: overridden in some filetypes below
  nnoremap <leader>k <Cmd>normal! K<CR>

  command! -nargs=* MyMan call s:mykeywordprg(<f-args>)
  function! s:mykeywordprg(...) abort
    if !empty(get(b:, 'manpage', ''))
      execute 'Man' b:manpage
      let keyword = printf('%s%s', 
	    \ get(b:, 'manpage_search_prefix', ''),
	    \ a:0 ? a:1 : expand('<cword>')
      	    \ )
      " very magic, beginning of line or after whitespace, allow optional word characters after the keyword
      call search('\v(^|\s)\zs'/..keyword..'\w*')
    endif
  endfunction

  " au BufRead,BufNewFile *alacritty.*ml call s:setup('5 alacritty')
  au FileType kitty,tmux setlocal iskeyword+=- keywordprg=:MyMan | let b:manpage = &filetype
  au FileType ghostty setl isk+=- kp=:MyMan | let b:manpage = &ft | let b:manpage_search_prefix = '--'
  au FileType gitconfig,gitconfig.chezmoitmpl call s:setup('git-config(1)')
  au FileType sshconfig call s:setup('ssh')
  au FileType lua setlocal keywordprg=:help iskeyword+=-
  au FileType sh  setlocal keywordprg=:Man  iskeyword-=_
  " au FileType tex nnoremap <silent><buffer> <leader>K <Plug>(vimtex-doc-package)
  au FileType vim nnoremap <silent><buffer> K <Plug>ScripteaseHelp
augroup END
augroup vimrc.navigation
  au!
  set scrolloff=999
  set virtualedit=block
  if has('nvim')
    set jumpoptions+=view
    set mousescroll=hor:0
    set smoothscroll
  endif
  nnoremap <BS> :bprevious<CR>
  nnoremap <C-BS> g;
  nnoremap <C-q> <Cmd>wincmd c<CR>
  nnoremap <C-w><C-s> <Cmd>sbprevious<CR>
  nnoremap <C-w><C-v> :<C-u>vsplit #<CR>
  " nnoremap <C-w>-     <C-w>s
  " nnoremap <C-w><Bar> <C-w>v
  " nnoremap <S-Tab>    <Cmd>wincmd w<CR>
  " restore cursor position upon reopening files
  au BufWinEnter * exe "silent! normal! g`\"zv"
augroup END
augroup vimrc.os
  au!
  " create parent directories when saving files
  au BufWritePre,FileWritePre * if @% !~# '\(://\)' | call mkdir(expand('<afile>:p:h'), 'p') | endif
  if has('nvim')
    set backup
    set backupext=.bak
    set backupdir=~/.local/state/nvim/backup//
    set backupskip+=~/.cache/*
    " default `blank,buffers,curdir,folds,help,tabpages,winsize,terminal`
    set sessionoptions-=blank
    set sessionoptions-=curdir
    set sessionoptions-=terminal
    " au SessionLoadPre   * echom '[SessionLoadPre] this session: '..v:this_session
    " au SessionLoadPost  * silent! lua vim.fs.rm(vim.v.this_session)
    " au SessionWritePost * echom '[SessionWritePost] this session: '..v:this_session
    command! Restart exe 'mks!' stdpath('data')..'/Session.vim'<Bar>exe 'sil conf restart so' v:this_session
  endif
  " if the system has both executables, don't set undofile for vim
  let &undofile = (has('nvim') || !executable('nvim')) ? 1 : &undofile
augroup END
augroup vimrc.registers
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
augroup vimrc.search/spell
  au!
  set findfunc=file#find
  set ignorecase
  set jumpoptions+=stack
  set showmatch
  set smartcase
  " set suffixes " TODO:
  set wildignore+=*.o,*.out,*.a,*.so
  " make `n` and `N` behave the same way for `?` and `/` searches
  " https://github.com/mhinz/vim-galore?tab=readme-ov-file#saner-behavior-of-n-and-n
  " NOTE: 'Nn'[v:searchforward] == (v:searchforward ? 'n' : 'N')
  nnoremap <expr> n (v:searchforward ? 'n' : 'N')..'zv'
  nnoremap <expr> N (v:searchforward ? 'N' : 'n')..'zv'
  " TODO: 
  " see `:h :mkspell` and vim.treesitter's `@nospell`
  let &spellfile ~/.vim/.spell/en.utf-8.add'
  autocmd FileType tex,markdown,rmd,quarto setlocal spell
augroup END
augroup vimrc.term
  au!
  tnoremap <C-P> <C-\><C-N>p<C-\><C-N>a
  tnoremap <expr> <C-R> '<C-\><C-N>"'..nr2char(getchar())..'pi'
  if has('nvim')
    au TermOpen * let g:last_channel = &channel
    " autocmd TermRequest * call term#print_request()
    autocmd TermRequest * call term#handleOSC7()
  endif
augroup END
augroup vimrc.ui
  au!
  set cursorline
  set list
  set number
  set signcolumn=number
  set tabline=%!vimline#tabline#()
  set title
  " set termguicolors

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

let g:mapleader      = ','
let g:maplocalleader = '\'

nnoremap <Space> :
nnoremap : ,
xmap <Space> <leader>
" prefer `'` for marks
nnoremap ` ~
nnoremap ~ `

" when in doubt, pinky out
nnoremap <C-c> ciw
nnoremap <C-e> <Cmd>lua Snacks.explorer.open({cwd = Snacks.git.get_root()})<CR>
" reserve - (hyphen) for vim-vinegar
nnoremap _ <Cmd>lua Snacks.explorer.reveal()<CR>
nnoremap <C-m> <Cmd>message<CR>
" open the pager (`ui2`)
nnoremap <C-,> g<

" cmd/super
xnoremap <D-c> "+y

nnoremap <D-r> <Cmd>Restart<CR>
nnoremap <D-s> <Cmd>write ++p<CR>

xnoremap < <gv
xnoremap > >gv
xnoremap <C-s> :sort<CR>
" TODO: diff?
" nnoremap dp dp']c
" nnoremap do do]c
nnoremap zJ <Plug>(unimpaired-move-down)kJ

nnoremap <leader>da <Cmd>ALEInfo<CR>
nnoremap <leader>db <Cmd>verb se buftype? bufhidden? buflisted? filetype? syntax?<CR>
nnoremap <leader>df <Cmd>verb se foldenable? foldmethod? foldexpr? foldlevel? foldlevelstart? foldminlines?<CR>
nnoremap <leader>ds <Cmd>verb se shell? shellcmdflag? shellpipe? shellquote? shellredir? shellslash? shellxquote?<CR>
nnoremap <leader>di <Cmd>Inspect<CR>
nnoremap <leader>dI <Cmd>Inspect!<CR>
nnoremap <leader>dT <Cmd>lua vim.treesitter.inspect_tree(); vim.api.nvim_input('I')<CR>
nnoremap <leader>dF <Cmd>=vim.filetype.inspect()<CR>
nnoremap <leader>dq <Cmd>lua vim.diagnostic.setloclist()<CR>
nnoremap <leader>dQ <Cmd>lua vim.diagnostic.setqflist()<CR>

nnoremap <Bslash>i <Cmd>call edit#($MYVIMRC)<CR>
nnoremap <Bslash>\ <Cmd>call edit#readme()<CR>
nnoremap <leader>fS <Cmd>call edit#snippets()<CR>
nnoremap <leader>ft <Cmd>call edit#ftplugin()<CR>
nnoremap <leader>fD <Cmd>Delete!<Bar>bwipeout #<CR>
nnoremap <leader>fT :set ft=<C-R>=&ft<CR><Bar>Info 'ft reloaded!'<CR>
nnoremap <leader>fw <Cmd>call format#clean_whitespace()<CR>

" tabpages
nnoremap ]<Tab> <Cmd>tabnext<CR>
nnoremap [<Tab> <Cmd>tabprevious<CR>
nnoremap <leader><Tab><Tab> <Cmd>tabnew<CR>
nnoremap <leader><Tab>d <Cmd>tabclose<CR>
nnoremap <leader><Tab>D <Cmd>tabonly<CR>
nnoremap <leader><Tab>f :<C-U>tabfind<Space>

" editing
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

" recursive maps
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
endif

call plug#begin()
" Plug 'andymass/vim-matchup'
" Plug 'bullets-vim/bullets.vim'
" Plug 'christoomey/vim-tmux-navigator'
" Plug 'dstein64/vim-startuptime'
Plug 'dense-analysis/ale'
" Plug 'justinmk/vim-dirvish'
" Plug 'justinmk/vim-ug'
" Plug 'justinmk/guh.nvim'
" Plug 'romainl/vim-qf.git'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-capslock'
Plug 'tpope/vim-characterize'
Plug 'tpope/vim-dadbod'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'
Plug 'tpope/vim-rsi'
Plug 'tpope/vim-scriptease'
Plug 'tpope/vim-speeddating'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-tbone'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-vinegar'
" Plug 'vuciv/golf'
Plug 'AndrewRadev/splitjoin.vim'
" Plug 'Konfekt/vim-formatprgs'
if !has('nvim')
  Plug 'AndrewRadev/dsf.vim'
  Plug 'Konfekt/FastFold'
  Plug 'github/copilot.vim'
  Plug 'junegunn/vim-easy-align'
  Plug 'wellle/targets.vim'
  Plug 'wellle/tmux-complete.vim'
else
  Plug! 'folke/snacks.nvim'
  Plug 'folke/lazydev.nvim'
  Plug 'folke/tokyonight.nvim'
  Plug 'folke/which-key.nvim'
  Plug 'nvim-mini/mini.nvim'
  Plug 'neovim/nvim-lspconfig'
  Plug 'b0o/SchemaStore.nvim'
  Plug 'chrisgrieser/nvim-scissors'
  Plug 'MeanderingProgrammer/render-markdown.nvim'
endif
" Plug 'Vimjas/vint'
Plug 'lervag/vimtex'
let g:vimtex_format_enabled = 1
" let g:vimtex_mappings_disable = {'n': ['K']}
" let g:vimtex_quickfix_method = executable('pplatx') ? 'pplatex' : 'latexlog'

Plug 'iamcco/markdown-preview.nvim'
" call mkdp#install()

Plug 'R-nvim/R.nvim'
" stop registering plugins...
call plug#end()

command! -nargs=* Diff call cmd#diff#(<f-args>)

command! -nargs=1 -complete=customlist,cmd#scp#complete Scp call cmd#scp#(<f-args>)

" `https://github.com/neovim/neovim/discussions/38256`
" Usage: $`nvim +Clipboard` or `alias pbedit='nvim +Clipboard'`
command! Clipboard call cmd#clipboard#()

if !exists(':hardcopy') " TODO: use `jobstart` to avoid the Snacks dependency
  command! Hardcopy lua Snacks.terminal.open(([[vim -esNu NONE %s -c 'hardcopy | q!']]):format(vim.api.nvim_buf_get_name(0)))
endif

nnoremap zq <Cmd>call vim#with#savedView('call format#buffer()')<CR>
nnoremap ZF <Cmd>echom 'formatting...'<Bar>ALEFix<CR>
nnoremap ZW <Cmd>echom 'formatting and saving...'<Bar>ALEFix<Bar>write!<CR>

" configure the modeline to create folds on the augroups
" vim: fdm=marker fdl=0 fmr=augroup\ vimrc,END
