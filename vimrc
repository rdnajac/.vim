
" rdnajac's vimrc {{{
if !has('nvim')
  " sensible.vim {{{
  if &compatible                  " technically, vim is always incompatible when a
    set nocompatible              " vimrc is present, but let's handle the edge case
  endif                           " when vim is run with the -u flag

  if has('langmap') && exists('+langremap') && &langremap
    set nolangremap  " Disable a legacy behavior that can break plugin maps.
  endif

  if !(exists('g:did_load_filetypes') && exists('g:did_load_ftplugin') && exists('g:did_indent_on'))
    filetype plugin indent on
  endif

  if has('syntax') && !exists('g:syntax_on')
    syntax enable
  endif

  " Correctly highlight $() and other modern affordances in filetype=sh.
  " if !exists('g:is_posix') && !exists('g:is_bash') && !exists('g:is_kornshell') && !exists('g:is_dash')
  "   let g:is_posix = 1
  " endif
  " Load matchit.vim, but only if the user hasn't installed a newer version.
  if !exists('g:loaded_matchit') && findfile('plugin/matchit.vim', &rtp) ==# ''
    runtime! macros/matchit.vim
  endif
  " Enable the :Man command shipped inside Vim's man filetype plugin.
  if exists(':Man') != 2 && !exists('g:loaded_man') && &filetype !=? 'man' && !has('nvim')
    runtime ftplugin/man.vim
  endif
  " }}}
  set encoding=utf-8              " http://rbtnn.hateblo.jp/entry/2014/12/28/010913
  scriptencoding utf-8            " see `:h :scriptencoding`
  set mouse=a                     " wait, that's illegal
  set hidden                      " enable background buffers
  set autoindent smarttab         " enable auto-indent and smart tabbing
  set autoread autowrite          " automatically read/write files when changed
  set backspace=indent,eol,start  " configure backspace behavior to be more intuitive
  set formatoptions+=j            " delete comment character when joining lines
  " set formatoptions-=o          " don't continue comments when pressing 'o'
  set hlsearch incsearch          " highlighted, incremental search
  set swapfile backup undofile    " {{{
  function! s:MkdirIfNotExists(dir) abort
    if !isdirectory(a:dir)
      call mkdir(a:dir, 'p', 0700)
    endif
  endfunction

  let &backupdir = expand('~/.vim/.backup')
  let &directory = expand('~/.vim/.swap')
  set undodir=~/.vim/.undo

  call s:MkdirIfNotExists(&backupdir)
  call s:MkdirIfNotExists(&directory)
  call s:MkdirIfNotExists(&undodir)
  set spellfile=~/.vim/.spell/en.utf-8.add
  set viminfo='10000,n~/.vim/.viminfo
  set clipboard=unnamed
  " }}}
  " performance {{{
  set updatetime=100             " used for CursorHold autocommands
  if &ttimeoutlen == -1
    set ttimeout
    set ttimeoutlen=100
  endif
" }}}
else
  set clipboard=unnamedplus     " neovim-specific settings can go here
endif
" }}}
set termguicolors
silent! color scheme

set autochdir                     " change directory to the file being edited
set completeopt=menuone,noselect  " show menu even if there's only one match
set foldopen+=insert,jump         " open folds when jumping to them or entering insert mode
set ignorecase smartcase          " ignore case when searching, unless there's a capital letter
set iskeyword+=-                  " treat hyphens as part of a word
set lazyredraw                    " don't redraw the screen while executing macros, etc.
set path+=~/.vim/**,~/cbmf/**     " search these directories for files
set report=0                      " display how many replacements were made
set shiftround
set shortmess+=A                  " avoid 'hit-enter' prompts
set softtabstop=2 shiftwidth=2    " don't change tabstop!
set whichwrap+=<,>,[,],h,l        " wrap around newlines with these keys 
set wildmenu                      " just use the default wildmode with this setting
set nowrap                        " don't wrap lines by default
set linebreak                     " if we have to wrap lines, don't split words
set number relativenumber         " show (relative) line numbers
set numberwidth=3                 " line number column padding
set showmatch                     " highlight matching brackets
set cursorline                    " highlight the current line
" set pumheight=10
" set signcolumn=yes
set splitbelow splitright         " where to open new splits by default
set scrolloff=4 sidescrolloff=0   " scroll settings
set signcolumn=no
set tabline=%!display#MyTabline()
set showcmd
" set showcmdloc=statusline   " show command in statusline 
" set cmdheight=1              " height of the command line
"
" statusline configuration {{{
set statusline=				    " Clear the status line
set statusline+=\ %F\ %y\ %r          " File path, modified flag, file type, read-only flag
"set statusline+=%{FugitiveStatusline()}   " Git branch
set statusline+=%=                        " Right align the following items
" set statusline+=ascii:\ %3b\ hex:\ 0x%02B\ " ASCII and hex value of char under cursor
" line length: %3l, column: %2c, percentage through file: %3p, total lines: %L
" add ling length to statusline
set statusline+=%S
set statusline+=strwidth=%{strwidth(getline('.'))} 
set statusline+=\ [%2v,\%P]
" }}}

" fillchars control the appearance of folds
set fillchars=fold:\ ,foldopen:▾,foldclose:▸,foldsep:│
set fillchars+=eob:\                " don't show end of buffer as a column of ~
set fillchars+=stl:\                " display spaces properly in statusline

" listchars control the appearance of whitespace
set listchars=trail:¿,tab:→\

" set isfname+={,},\",\<,\>,(,),[,],\:

augroup vimrc
  autocmd!
  " quit special buffers with 'q'
  autocmd FileType help,man,qf,fugitive,ale-info silent! nnoremap <silent> <buffer> q :<C-U>close<CR> | set nobuflisted
  " automatically quit cmd window
  autocmd CmdwinEnter * quit
  " When editing a file, always jump to the last known cursor position.
  autocmd BufReadPost *
        \ let line = line("'\"")
        \ | if line >= 1 && line <= line("$")
        \ |   execute "normal! g`\""
        \ | endif
augroup END

" plugins are saved in ~/.vim/pack/plugins/opt by default
" so we have to manually `packadd!` them

" core plugins
packadd! ale
packadd! copilot.vim
packadd! vim-which-key

" tpope plugins
packadd! vim-commentary
packadd! vim-eunuch
packadd! vim-repeat 
packadd! vim-surround
packadd! vim-tbone
packadd! vim-vinegar

" keymaps {{{
let g:mapleader = ' '
let g:maplocalleader = ','

" Which-key setup {{{
nnoremap <silent> <leader>      :<c-u>WhichKey '<Space>'<CR>
vnoremap <silent> <leader>      :<c-u>WhichKey '<Space>'<CR>
" nnoremap <silent> <localleader> :<c-u>WhichKey  ','<CR>
" vnoremap <silent> <localleader> :<c-u>WhichKey  ','<CR>
call which_key#register('<Space>', "g:which_key_map")

" Create menus based on existing mappings. These must be manually
" updated, but at least we don't rely on which-key to map our keys.
let g:which_key_map = {}

" autocmd! FileType which_key
" autocmd  FileType which_key set laststatus=0 noshowmode noruler
"   \| autocmd BufLeave <buffer> set laststatus=2 showmode
" }}}

" quick escape
inoremap jk <esc>
inoremap kj <esc>
vnoremap jk <esc>
vnoremap kj <esc>

" ctrl + char
nnoremap <C-q> :wqall<CR>
nnoremap <leader>w :w<CR>
nnoremap <leader>r :source $MYVIMRC<CR>
nnoremap <leader>q :call utils#smartQuit()<CR>
nnoremap <leader>h :set hlsearch!<CR>
vnoremap <leader>r :<C-u>call utils#replaceSelection()<CR>

" info in normal mode
nnoremap ? :call utils#getInfo()<CR>
nnoremap <leader>v :execute 'verbose set ' . <cword> . '?'
nnoremap <leader>c :echo synIDattr(synIDtrans(synID(line('.'), col('.'), 1)), 'name')<CR>

" edit vim config files {{{
nnoremap <leader>ev :e $MYVIMRC<CR>
nnoremap <leader>ec :find scheme.vim<CR>
nnoremap <leader>ek :find _keymaps.vim<CR>
nnoremap <leader>ep :find after/plugin/settings.vim<CR>
nnoremap <leader>es :UltiSnipsEdit<CR>

let g:which_key_map.e = { 'name' : '+edit',
      \ 'v' : 'edit vimrc',
      \ 'c' : 'edit colorscheme',
      \ 'd' : 'edit display settings',
      \ 'k' : 'edit keymaps',
      \ 'p' : 'edit plugin settings',
      \ 's' : 'edit snippets',
      \ }
"}}}
" toggle settings {{{
nnoremap <leader>sh :set hlsearch!<CR>
nnoremap <leader>sl :set list!<CR>
nnoremap <leader>sn :set number!<CR>
nnoremap <leader>sr :set relativenumber!<CR>
nnoremap <leader>sw :set wrap!<CR>
nnoremap <leader>ss :set spell!<CR>
nnoremap <leader>scl :set cursorline!<CR>
nnoremap <leader>scc :set cursorcolumn!<CR>
nnoremap <leader>st :let &showtabline = (&showtabline == 2 ? 0 : 2)<CR>
nnoremap <leader>ss :let &laststatus = (&laststatus == 2 ? 0 : 2)<CR>

let g:which_key_map.s = { 'name' : '+set/toggle',
      \ 'h' : 'highlight search',
      \ 'l' : 'list',
      \ 'n' : 'number',
      \ 'r' : 'relative number',
      \ 'w' : 'wrap',
      \ 's' : 'spell',
      \ 'cl' : 'cursor line',
      \ 'cc' : 'cursor column',
      \ }
" }}}

" indent/dedent visual block
nnoremap > V`]>
nnoremap < V`]<

" buffers and windows
nnoremap <tab>   :bnext<CR>
nnoremap <s-tab> :bprevious<CR>
nnoremap <leader><tab> :b#<CR>

" file operations
nnoremap <leader>fa :argadd <c-r>=fnameescape(expand('%:p:h'))<CR>/*<C-d>
nnoremap <leader>ff :find<space>
nnoremap <leader>fe :e!<CR>
nnoremap <leader>fm :make<CR>
nnoremap <leader>fx :!./%<CR>
nnoremap <leader>fb :b <C-d>
nnoremap <leader>ft :TTags<space>*<space>*<space>.<CR>
" +file/find which-key setup {{{
let g:which_key_map.f = { 'name' : '+file/find',
      \ 'a' : 'add arg',
      \ 'f' : 'find file (in path)',
      \ 'e' : 'file edit (force reload)',
      \ 'm' : 'file make',
      \ 'x' : 'file execute',
      \ 'b' : 'find buffer',
      \ 't' : 'find tag',
      \ }
" }}}

" better completion
inoremap <silent> <localleader>o <C-x><C-o>
inoremap <silent> <localleader>f <C-x><C-f>
inoremap <silent> <localleader>i <C-x><C-i>
inoremap <silent> <localleader>l <C-x><C-l>
inoremap <silent> <localleader>n <C-x><C-n>
inoremap <silent> <localleader>t <C-x><C-]>
inoremap <silent> <localleader>u <C-x><C-u>

" no more fat fingers!
cnoreabbrev <expr> X getcmdtype() == ':' && getcmdline() == 'X' ? 'x' : 'X'
cnoreabbrev <expr> Q getcmdtype() == ':' && getcmdline() == 'Q' ? 'w' : 'Q'

" run current line
" nnoremap <leader>rl ^yg_:r!<C-r>"<CR>
" }}}

" romainl gists {{{
"
" https://gist.github.com/romainl/3e0cb99343c72d04e9bc10f6d76ebbef
" return to the mark with ` plus letter
augroup AutomaticMarks 
  autocmd!
  autocmd BufLeave vimrc        normal! mV
  autocmd BufLeave *.vim        normal! mV
  autocmd BufLeave *.md         normal! mM
  autocmd BufLeave *.sh         normal! mS
augroup END

" Slightly more intuitive gt/gT (may need some unlearning to get used to)
" https://gist.github.com/romainl/0f589e07a079ea4b7a77fd66ef16ebee
" nnoremap <expr> gt ":tabnext +" . v:count1 . '<CR>'
" nnoremap <expr> gT ":tabnext -" . v:count1 . '<CR>'

" gq wrapper that:
" - tries its best at keeping the cursor in place
" - tries to handle formatter errors
" function! Format(type, ...)
"     normal! '[v']gq
"     if v:shell_error > 0
"         silent undo
"         redraw
"         echomsg 'formatprg "' . &formatprg . '" exited with status ' . v:shell_error
"     endif
"     call winrestview(w:gqview)
"     unlet w:gqview
" endfunction
" nmap <silent> GQ :let w:gqview = winsaveview()<CR>:set opfunc=Format<CR>g@"
"
" Use a bunch of standard UNIX commands for quick an dirty
" whitespace-ba sed alignment
" function! Align()
" 	'<,'>!column -t|sed 's/  \(\S\)/ \1/g'
" 	normal gv=
" endfunction
" xnoremap <silent> <key> :<C-u>silent call Align()<CR>

" function! BreakHere()
" 	s/^\(\s*\)\(.\{-}\)\(\s*\)\(\%#\)\(\s*\)\(.*\)/\1\2\r\1\4\6
" 	call histdel("/", -1)
" endfunction
" nnoremap <key> :<C-u>call BreakHere()<CR>

" TODO: redirect output
" https://gist.github.com/romainl/eae0a260ab9c135390c30cd370c20cd7
" TODO: quicklist manipulation
" https://github.com/romainl/vim-qlist
" }}}
" defaults.vim {{{
" Do not recognize octal numbers for Ctrl-A and Ctrl-X
set nrformats-=octal

" CTRL-U in insert mode deletes a lot.
" Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" I like highlighting strings inside C comments.
let c_comment_strings=1

" Convenient command to see the difference between 
" the current buffer and the file it was loaded from.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
        \ | wincmd p | diffthis
endif
" }}}
" ignore these files and directories {{{
set wildignore+=*.o,*.out,*.a,*.so,*.lib,*.bin,*/.git/*   " General build files
set wildignore+=*.pyo,*.pyd,*/.cache/*,*/dist/*           " Python files and directories
set wildignore+=*.swp,*.swo,*.tmp,*.temp                  " Swap and temporary files
set wildignore+=*.pdf,*.aux,*.fdb_latexmk,*.fls           " LaTeX files
set wildignore+=*.zip,*.tar.gz,*.rar,*.7z,*.tar.xz,*.tgz  " Archives and compressed files
set wildignore+=*.cmake,*.cmake.in,*.cmod,*/bin/*,*/build/* " C/C++ files and directories
set wildignore+=*/out/*,*/vendor/*,*/target/*,*/.vscode/*,*/.idea/*
set wildignore+=*.jpg,*.png,*.gif,*.bmp,*.tiff,*.ico,*.svg,*.webp,*.img
set wildignore+=*.mp*p4,*.avi,*.mkv,*.mov,*.flv,*.wmv,*.webm,*.m4v,*.flac,*.wav
set wildignore+=*.deb,*.rpm,*.dylib,*.app,*.dmg,*.DS_Store,*.exe,*.dll,*.msi,Thumbs.db
" }}}
" set nomodeline {{{
" Modelines have historically been a source of security vulnerabilities. 
" TODO: disable modelines and use securemodelines
" http://www.vim.org/scripts/script.php?script_id=1876
" }}}
" vim: ft=vim: fdm=marker:
