" nice stuff nvim gave us
" see `:h default-mappings`
" `~/.local/share/nvim/share/nvim/runtime/lua/vim/_defaults.lua:43`

" - Y |Y-default|
nnoremap Y y$

" - <C-U> |i_CTRL-U-default|
" - <C-W> |i_CTRL-W-default|
inoremap <C-U> <C-G>u<C-U>
inoremap <C-W> <C-G>u<C-W>

" - <C-L> |CTRL-L-default|
nnoremap <C-L> <Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>

" - & |&-default|
nnoremap & :&&<CR>

" - Q |v_Q-default|
" - @ |v_@-default|
xnoremap <silent><expr> Q mode() ==# 'V' ? ':normal! @<C-R>=reg_recorded()<CR><CR>' : 'Q'
xnoremap <silent><expr> @ mode() ==# 'V' ? ':normal! @'.getcharstr().'<CR>'         : '@'

" TODO: need s:visual_search() helper function
" - # |v_#-default|
" - * |v_star-default|

" - gc |gc-default| |v_gc-default| |o_gc-default|
" - gcc |gcc-default|
" - |gO|

" bracket mappings
" da

" - |[q| |]q| |[Q| |]Q| |[CTRL-Q| |]CTRL-Q|

" - |[l| |]l| |[L| |]L| |[CTRL-L| |]CTRL-L|

" - |[t| |]t| |[T| |]T| |[CTRL-T| |]CTRL-T|

" argument:   |[a| |]a| |[A| |]A|
" buffer:     |[b| |]b| |[B| |]B|
" diagnostic: |[d| |]d| |[D| |]D|

" - |[<Space>| |]<Space>|

" - 'autoindent' is enabled
" - 'autoread' is enabled (works in all UIs, including terminal)
" - 'background' defaults to "dark" (unless set automatically by the terminal/UI)
" - 'backupdir' defaults to .,~/.local/state/nvim/backup// (|xdg|), auto-created
" - 'belloff' defaults to "all"
" - 'comments' includes "fb:•"
" - 'commentstring' defaults to ""
" - 'compatible' is always disabled
" - 'complete' excludes "i"
" - 'completeopt' defaults to "menu,popup"
" - 'define' defaults to "". The C ftplugin sets it to "^\\s*#\\s*define"
setglobal path=.,,
" - 'diffopt' includes "linematch:40"
" - 'directory' defaults to ~/.local/state/nvim/swap// (|xdg|), auto-created
" - 'display' defaults to "lastline"
" - 'encoding' is UTF-8 (cf. 'fileencoding' for file-content encoding)
" - 'fillchars' defaults (in effect) to "vert:│,fold:·,foldsep:│"
" - 'formatoptions' defaults to "tcqj"
" - 'grepprg' uses the -H and -I flags for regular grep,
"   and defaults to using ripgrep if available
if executable('rg')
  set grepprg=rg\ --vimgrep\ --uu
  set grepformat=%f:%l:%c:%m
else
  set grepprg=grep\ -HIn\ $*\ /dev/null
endif
" - 'hidden' is enabled
" - 'history' defaults to 10000 (the maximum)
" - 'hlsearch' is enabled
" - 'include' defaults to "". The C ftplugin sets it to "^\\s*#\\s*include"
" - 'incsearch' is enabled
" - 'isfname' does not include ":" (on Windows).
" - 'joinspaces' is disabled
" - 'jumpoptions' defaults to "clean"
" - 'langnoremap' is enabled
" - 'langremap' is disabled
" - 'laststatus' defaults to 2 (statusline is always shown)
" - 'listchars' defaults to "tab:> ,trail:-,nbsp:+"
" - 'maxsearchcount' defaults to 999
" - 'mouse' defaults to "nvi"
" - 'mousemodel' defaults to "popup_setpos"
" - 'nrformats' defaults to "bin,hex"
" - 'path' defaults to ".,,". The C ftplugin adds "/usr/include" if it exists.
setglobal path=.,,
" - 'sessionoptions' includes "unix,slash", excludes "options"
" - 'shortmess' includes "CF", excludes "S"
" - 'sidescroll' defaults to 1
" - 'smarttab' is enabled
" - 'startofline' is disabled
" - 'switchbuf' defaults to "uselast"
" - 'tabpagemax' defaults to 50
" - 'tags' defaults to "./tags;,tags"
" - 'termguicolors' is enabled by default if Nvim can detect support from the host terminal
" - 'ttimeout' is enabled
" - 'ttimeoutlen' defaults to 50
" - 'ttyfast' is always set
" - 'undodir' defaults to ~/.local/state/nvim/undo// (|xdg|), auto-created
" - 'viewoptions' includes "unix,slash", excludes "options"
" - 'viminfo' includes "!"
" - 'wildoptions' defaults to "pum,tagfile"
set wildoptions=pum,tagfile

function! vim#defaults#() abort
  " vim sets defaults that are only useful for C/C++
  " taken from `vim-apathy`, along with setglobal define and path
  setglobal include=
  setglobal includeexpr=

  let &viminfofile = g:vimrc#home . '.viminfo'
  let &verbosefile = g:vimrc#home . '.vimlog.txt'
endfunction
