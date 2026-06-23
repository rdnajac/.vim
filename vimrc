call vimrc#init()
augroup vimrc-apathy
  autocmd!
  setglobal isfname+=@-@ " `tpope/vim-apathy`
  if has('nvim')
    set backup
    set backupext=.bak
    set backupdir=~/.local/state/nvim/backup//
    set backupskip+=~/.cache/*
    " set nocdhome
  else
    " vim sets defaults that are only useful for C/C++
    setglobal define= include= includeexpr= path=.,,
    if !isdirectory(g:stdpath#state)
      call mkdir(g:stdpath#state, 'p')
    endif
    let &viminfofile = g:stdpath#state .. '/viminfo'
    let &verbosefile = g:stdpath#state .. '/vimlog.txt'
  endif
  " set suffixes " TODO:
  set wildignore+=*.o,*.out,*.a,*.so
  " if the system has both executables, don't set undofile for vim
  let &undofile = (has('nvim') || !executable('nvim')) ? 1 : &undofile
  au FileType c,cpp,python,sh exe printf('call vim#apathy#%s()', &filetype)
  au BufWritePre,FileWritePre * if @% !~# '\(://\)' | call mkdir(expand('<afile>:p:h'), 'p') | endif
augroup END
augroup vimrc-buffers
  autocmd!
  set splitbelow
  set splitright
  set splitkeep=screen
  set switchbuf+=vsplit " NOTE: minimax wants `usetab`
  " close special buffers with `q` if not already mapped
  au BufEnter * if !empty(&buftype) && empty(maparg('q', 'n', 0, 1)) | nnoremap <buffer> q <Cmd>wincmd c<CR> | endif
augroup END
augroup vimrc-cmd/completion
  autocmd!
  command! Clipboard call cmd#clipboard()
  command! -nargs=* Diff call cmd#diff(<f-args>)
  if !exists(':hardcopy')
    command! Hardcopy call cmd#hardcopy()
  endif
  command! -nargs=1 -complete=customlist,cmd#scp_complete Scp call cmd#scp(<f-args>)
  " set autocomplete
  " see `:h |ins-completion|`
  " set completeopt=menu,preview " vim default
  " set completeopt=menu,popup   " neovim default
  " set completeopt=menu,preview,longest
  " set completeopt+=preinsert

  " see `:h |cmdline-completion|`
  set wildmode=noselect:lastused,full
  set wildoptions=pum
  " autocmd CmdlineChanged [:\/\?] call wildtrigger()
  " au CursorHold,CursorHoldI * if getcmdtype() =~# '[:\/\?]' | call wildtrigger() | endif
  " NOTE: After navigating command-line history, the first call to
  " `wildtrigger()` is a no-op; a second call is needed to start expansion.
  " This is to support history navigation in command-line autocompletion.

  " navigate completion menu with arrow keys
  cnoremap <expr> <Down> wildmenumode() ? "\<C-n>" : "\<Down>"
  cnoremap <expr> <Up>   wildmenumode() ? "\<C-p>" : "\<Up>"

  call cmd#abbrev('f', 'find')
  call cmd#abbrev('??', 'verbose set ?<Left>')
  call cmd#abbrev('dd', 'echom')
  call cmd#abbrev('vv', 'verbose')
  call cmd#abbrev('mm', 'verbose map')
  call cmd#abbrev('ab', 'verbose ab')
  if has('nvim')
    call cmd#abbrev('man', 'Man')
    call cmd#abbrev('open', 'Open')
  endif
  " use expression mappings for evaluations
  " cnoreabbrev <expr> %% expand('%:p:h')
augroup END
augroup vimrc-debug/diagnostics
  autocmd!
  nnoremap <leader>i <Cmd>Inspect<CR>
  nnoremap <leader>I <Cmd>Inspect!<CR>
  nnoremap <leader>T <Cmd>lua vim.treesitter.inspect_tree(); vim.api.nvim_input('I')<CR>

  nnoremap <leader>db <Cmd>verb set buftype? bufhidden? buflisted? filetype? syntax?<CR>
  nnoremap <leader>df <Cmd>verb set foldenable? foldmethod? foldexpr? foldlevel? foldlevelstart? foldminlines?<CR>
  nnoremap <leader>dF <Cmd>verb set formatprg? formatexpr? tagfunc? omnifunc?<CR>
  nnoremap <leader>ds <Cmd>verb set shell? shellcmdflag? shellpipe? shellquote? shellredir? shellslash? shellxquote?<CR>
  nnoremap <leader>dt <Cmd>verb set ft? tabstop? shiftwidth? softtabstop? expandtab? smarttab?<CR>
  nnoremap <leader>dq <Cmd>lua vim.diagnostic.setloclist()<CR>
  nnoremap <leader>dQ <Cmd>lua vim.diagnostic.setqflist()<CR>
augroup END
augroup vimrc-edit
  autocmd!
  set breakindent
  set breakindentopt=list:1 " TODO: from minimax; keep?
  set linebreak
  set shiftround
  " WARN: don't change tabstop!
  set shiftwidth=2
  set softtabstop=2
  " autocmd FileType markdown,tex setl sw=2 sts=2
  " autocmd FileType cpp  setl sw=4 sts=4
  " autocmd FileType c,sh setl sw=8 sts=8
  autocmd FileType quarto setl noai
  " TODO: 
  " vim.o.selection = 'exclusive'
  " vim.opt.virtualedit = { 'block', 'onemore' }

  " undo breakpoints
  inoremap , ,<C-g>u
  inoremap . .<C-g>u
  inoremap ; ;<C-g>u

  " change/delete current word
  nnoremap c*  *``cgn
  nnoremap c#  *``cgN
  nnoremap d*  *``dgn
  nnoremap d#  *``dgN

  nnoremap <C-c> ciw
  xnoremap <C-s> :sort<CR>

  " https://github.com/kaddkaka/vim_examples?tab=readme-ov-file
  " #repeat-last-change-in-all-of-file-global-repeat-similar-to-g
  nnoremap g. :%s//<C-R>./g<ESC>
  " #replace-only-within-selection
  xnoremap s :s/\%V
  " similarly, apply normal command to each line in selection
  xnoremap n :normal!<Space>
augroup END
augroup vimrc-fold/format
  autocmd!
  set foldclose=all
  set foldlevel=99
  " set foldlevelstart=0
  set foldminlines=3
  " set foldopen=all
  let g:vimsyn_folding = 'afl'

  au FileType vim     setl fdm=syntax commentstring=\"\ %s
  au FileType lua     setl fdm=expr   foldtext=fold#text_lua()
  au FileType vim,lua setl nowrap conceallevel=2
  " setlocal foldtext=v:vim.lsp.foldtext() TODO
  au FileType markdown,r,rmd,quarto setl fdm=expr fde=v:lua.vim.treesitter.foldexpr()]])

  " PERF: if executable(...) is slow
  au FileType html,markdown let &l:formatprg = 'prettier --stdin-filepath %'
  au FileType python        let &l:formatprg = 'ruff format -q --stdin-filename % -'
  autocmd FileType json setlocal formatexpr=v:lua.nv.json.formatexpr()

  " one or more special characters (digit, -, +, *),
  " possibly followed by `.` or `)`, whitespace
  " default:         `'^\s*\d\+[\]:.)}\t ]\s*'`
  set formatlistpat=^\s*[0-9\-\+\*]\+[\.\)]*\s\+

  " formatoptions get overriden by filetype plugins
  autocmd FileType * setl formatoptions-=o

  " format the whole buffer (`al`, see autoload/vimrc.vim) via a custom
  " operatorfunc: use 'formatprg' if set, else re-indent; see autoload/format.vim
  nnoremap zq <Cmd>call vim#with#savedView("set operatorfunc=format#opfunc\nnormal! g@al")<CR>
augroup END
augroup vimrc-hjkl
  autocmd!
  set timeoutlen=420
  set ttimeoutlen=69
  set whichwrap+=<,>,[,]
  nnoremap H ^
  nnoremap L $
  if has('nvim')
    set startofline " default changed from vim
    lua vim.keymap.set({ 'n', 'x' }, { 'j', '<Down>' }, [[v:count ? 'gj' : 'j']], { expr = true, remap = false })
    lua vim.keymap.set({ 'n', 'x' }, { 'k', '<Up>'   }, [[v:count ? 'gk' : 'k']], { expr = true, remap = false })
  else
    " handle wrapped lines better by preferring `gj` and `gk`
    for [key, dir] in items({ 'j': 'j', 'k': 'k', '<Down>': 'j', '<Up>': 'k' })
      execute printf('nnoremap <expr> %s (v:count ? "g%s" : "%s")', key, dir, dir)
      execute printf('xnoremap <expr> %s (v:count ? "g%s" : "%s")', key, dir, dir)
    endfor
  endif
  " window navigation with Shift + h/j/k/l
  " NOTE: S-Tab not detected in all terminals...
  for [dir, key] in items({'Left':'h', 'Down':'j', 'Up':'k', 'Right':'l'})
    exe $'nnoremap <S-{dir}> <Cmd>wincmd {key}<CR>'
    exe $'tnoremap <S-{dir}> <Cmd>wincmd {key}<CR>'
  endfor
  call jk#setup_escape_mappings() " TODO: use <C-c>
  " close folds when moving left at beginning of line
  " nnoremap <expr> h virtcol('.') <= indent('.') + 1 ? 'zc' : 'h'
  " indent/dedent visual selection
  xnoremap < <gv
  xnoremap > >gv
augroup END
augroup vimrc-keys
  autocmd!
  let g:mapleader      = ','
  let g:maplocalleader = '\'
  nnoremap <Space> :
  xnoremap <Space> <Leader>
  nnoremap : ,
  nnoremap ` ~
  nnoremap ~ `
augroup END
augroup vimrc-info
  autocmd!
  " preserve the original K mapping
  nnoremap <leader>k <Cmd>normal! K<CR>

  command! -nargs=* MyMan call s:mykeywordprg(<f-args>)
  function! s:mykeywordprg(...) abort
    if !empty(get(b:, 'manpage', ''))
      execute 'Man' b:manpage
      let keyword = printf('%s%s',
	    \ get(b:, 'manpage_search_prefix', ''),
	    \ a:0 ? a:1 : expand('<cword>')
	    \ )
      " very magic, beginning of line or after whitespace,
      " allow optional word characters after the keyword
      call search('\v(^|\s)\zs'..keyword..'\w*')
    endif
  endfunction

  function! s:manpage(name) abort
    setl isk+=- kp=:MyMan
    let b:manpage = a:name
  endfunction

  " au BufRead,BufNewFile *alacritty.*ml call s:setup('5 alacritty')
  au FileType ghostty                          let b:manpage_search_prefix = '--'
  au FileType kitty,tmux,ghostty               call s:manpage(&filetype)
  au FileType gitconfig,gitconfig.chezmoitmpl  call s:manpage('git-config(1)')
  au FileType sshconfig                        call s:manpage('ssh')
  au FileType tex nnoremap <silent><buffer> <localleader>k <Plug>(vimtex-doc-package)
  au FileType vim nnoremap <silent><buffer> <localleader>k <Plug>ScripteaseHelp
augroup END
augroup vimrc-join/jump
  autocmd!
  set jumpoptions+=stack
  if has('nvim')
    set jumpoptions+=view
  endif
  nnoremap zJ ddpkJ
  nnoremap dJ d0hJ
  nnoremap <localleader>i <Cmd>call edit#($MYVIMRC)<CR>
  nnoremap <localleader>\ <Cmd>call edit#readme()<CR>
  nnoremap <localleader>a <Cmd>call edit#ftplugin()<CR>
  nnoremap <localleader>s <Cmd>call edit#snippets()<CR>
  " restore cursor position upon reopening files
  au BufWinEnter * exe 'silent! normal! g`"'
augroup END
augroup vimrc-marks/messages
  autocmd!
  set report=0
  " nvim default: `ltToOCF`
  set shortmess+=a
  set shortmess+=A
  " set shortmess+=c
  au BufLeave vimrc call vimrc#set_marks()
augroup END
augroup vimrc-navigation
  autocmd!
  set scrolloff=999
  set virtualedit=block
  if has('nvim')
    set mousescroll=hor:0
    set smoothscroll
  endif

  " make `n` and `N` behave the same way for `?` and `/` searches
  " https://github.com/mhinz/vim-galore?tab=readme-ov-file#saner-behavior-of-n-and-n
  " NOTE: 'Nn'[v:searchforward] == (v:searchforward ? 'n' : 'N')
  nnoremap <expr> n (v:searchforward ? 'n' : 'N')..'zv'
  nnoremap <expr> N (v:searchforward ? 'N' : 'n')..'zv'

  nnoremap <BS> :bprevious<CR>
  nnoremap <C-BS> g;
  nnoremap <C-q>      <Cmd>wincmd c<CR>
  nnoremap <C-w><C-s> <Cmd>sbprevious<CR>
  nnoremap <C-w><C-v> :<C-u>vsplit #<CR>
  " nnoremap <C-w>-     <C-w>s
  " nnoremap <C-w><Bar> <C-w>v
  " nnoremap <S-Tab>    <Cmd>wincmd w<CR>
augroup END
augroup vimrc-qf
  autocmd!
  function! s:qf_signs() abort
    call sign_define('QFError', { 'text' : '💩'} )
    call sign_unplace('*')
    for item in getqflist()
      call sign_place(0, '', 'QFError', item.bufnr, {'lnum': item.lnum})
    endfor
  endfunction

  autocmd QuickFixCmdPost [^l]* cwindow | silent! call s:qf_signs()
  autocmd QuickFixCmdPost   l*  lwindow | silent! call s:qf_signs()
augroup END
augroup vimrc-registers
  autocmd!
  " delete/paste without yanking
  nnoremap dy "_dd
  vnoremap p "_dP
  vnoremap <BS> "_d
  vnoremap <C-BS> "_c

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
    autocmd TextPutPost,TextYankPost * silent! lua vim.hl.hl_op()
    autocmd UIEnter * call register#set_clipboard()
  endif
augroup END
augroup vimrc-search/sesh/spell
  autocmd!
  set findfunc=file#find
  set ignorecase
  set smartcase
  if !has('nvim')
    " set sessionoptions-=options " see `tpope/vim-obsession`
  else
    set sessionoptions=buffers,help,tabpages,winsize
    " au SessionLoadPre   * echom '[SessionLoadPre] this session: '..v:this_session
    " au SessionWritePost * echom '[SessionWritePost] this session: '..v:this_session
  endif
  " see `:h :mkspell` and vim.treesitter's `@nospell`
  " let &spellfile = '~/.vim/.spell/en.utf-8.add'
  " autocmd FileType tex setlocal spell
augroup END
augroup vimrc-tabs/term
  autocmd!
  nnoremap ]<Tab>         <Cmd>tabnext<CR>
  nnoremap [<Tab>         <Cmd>tabprevious<CR>
  nnoremap <leader><Tab>n <Cmd>tabnew<CR>
  nnoremap <leader><Tab>c <Cmd>tabclose<CR>
  nnoremap <leader><Tab>o <Cmd>tabonly<CR>
  nnoremap <leader><Tab>f :<C-U>tabfind<Space>

  tnoremap <C-P> <C-\><C-N>p<C-\><C-N>a
  tnoremap <expr> <C-R> '<C-\><C-N>"'..nr2char(getchar())..'pi'
  if has('nvim')
    au TermOpen * let g:last_channel = &channel
    autocmd TermRequest * call term#handleOSC7()
  endif
augroup END
augroup vimrc-vimrc
  autocmd!
  autocmd VimLeave * if v:dying | echo 'oof '..v:exiting | endif
augroup END
augroup vimrc-ui
  autocmd!
  set cursorline
  set list
  set number
  set signcolumn=number
  set showmatch
  set tabline=%!vimline#tabline#()
  set title
  " set termguicolors
  if has('nvim')
    " set cmdheight=0
    set laststatus=3
    set pumheight=10
    set pumblend=0
    set pumborder=rounded
    set winborder=rounded
    set wbr=%{%v:lua.nv.ui.winbar()%}
    call chromatophore#setup()
  endif
  " hide the statusline while in command mode
  " au CmdlineEnter * if &ls != 0 | let g:last_ls = &ls | set ls=0 |endif
  " au CmdlineLeave * if exists('g:last_ls') | let &ls = g:last_ls | unlet g:last_ls | endif

  " no cursorline in insert mode
  " au InsertLeave,WinEnter * if exists('w:had_cul') | setl cul | unlet w:had_cul | endif
  " au InsertEnter,WinLeave * if &cul | let w:had_cul = 1 | setl nocul | endif

  " relative numbers in visual mode only if number is already set
  au ModeChanged [vV\x16]*:*,*:[vV\x16]* if &nu | let &l:rnu = is#visual() | endif
  au WinEnter,WinLeave *                 if &nu | let &l:rnu = is#visual() | endif

  " automatically resize splits when the window is resized
  au VimResized * let s:tabpagenr = tabpagenr() | tabdo wincmd = | exe 'tabnext' s:tabpagenr
augroup END

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
Plug 'b0o/SchemaStore.nvim'
Plug 'chrisgrieser/nvim-scissors',
Plug 'dense-analysis/ale'
Plug 'folke/todo-comments.nvim'
Plug 'folke/tokyonight.nvim'
Plug 'folke/which-key.nvim'
Plug 'iamcco/markdown-preview.nvim', { 'build': { -> mkdp#install() } }
Plug 'lervag/vimtex'
Plug 'mason-org/mason.nvim'
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-mini/mini.nvim'
Plug 'nvim-treesitter/nvim-treesitter'
Plug 'nvim-treesitter/nvim-treesitter-context'
Plug 'nvim-treesitter/nvim-treesitter-textobjects'
Plug 'MeanderingProgrammer/render-markdown.nvim'
Plug 'R-nvim/R.nvim'
Plug 'Saghen/blink.lib'
Plug 'Saghen/blink.cmp'
" Plug 'Saghen/blink.cmp', { 'build': { -> 'lua require("blink.cmp").build:schedule()' } }
call plug#end()
