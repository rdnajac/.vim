function! vimrc#init() abort
  if !has('nvim')
    call vimrc#defaults()
    call vimrc#sensible()
  endif
endfunction

function! s:setmark(pattern, idx, line) abort
  let char = matchstr(a:line, a:pattern . '\zs.')
  if empty(char) | return | endif
  call setpos("'" . toupper(char), [0, a:idx + 1, 1, 0])
endfunction

" create marks for each augroup to jump to specific vimrc lines from anywhere
function! vimrc#set_marks() abort
  let lines = getline(1, '$')
  for i in range(len(lines))
    call s:setmark('^aug.\{-}vimrc\W', i, lines[i])
  endfor
  normal mV
endfunction

" nice stuff nvim gives us, ported to vimscript
" see `:h nvim-defaults` and `:h default-mappings`
function! vimrc#defaults() abort
  " - Y |Y-default|
  nnoremap Y y$

  " mimic os copy to clipboard
  " xnoremap <D-c> "+y
  " and save...
  " nnoremap <D-s> <Cmd>write ++p<CR>

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

  " bracket mappings
  " - |[q| |]q| |[Q| |]Q| |[CTRL-Q| |]CTRL-Q|
  " - |[l| |]l| |[L| |]L| |[CTRL-L| |]CTRL-L|
  " - |[t| |]t| |[T| |]T| |[CTRL-T| |]CTRL-T|

  " argument:   |[a| |]a| |[A| |]A|
  " buffer:     |[b| |]b| |[B| |]B|
  " diagnostic: |[d| |]d| |[D| |]D|

  " textobjects
  " inner/around line
  xnoremap il ^og_
  onoremap il :<C-u>norm vil<CR>

  " entire buffer
  xnoremap al ggVG
  onoremap al :<C-u>norm val<CR>

  " - `autoindent` is enabled
  " - `autoread` is enabled (works in all UIs, including terminal)
  " - `background` defaults to "dark" (unless set automatically by the terminal/UI)
  " - `backupdir` defaults to .,~/.local/state/nvim/backup// (|xdg|), auto-created
  " - `belloff` defaults to "all"
  " - `comments` includes "fb:•"
  " - `commentstring` defaults to ""
  " - `compatible` is always disabled
  " - `complete` excludes "i"
  " - `completeopt` defaults to "menu,popup"
  " - `define` defaults to "". The C ftplugin sets it to "^\\s*#\\s*define"
  " - `diffopt` includes "linematch:40"
  " - `directory` defaults to ~/.local/state/nvim/swap// (|xdg|), auto-created
  " - `display` defaults to "lastline"
  " - `encoding` is UTF-8 (cf. 'fileencoding' for file-content encoding)
  " - `fillchars` defaults (in effect) to "vert:│,fold:·,foldsep:│"
  " - `formatoptions` defaults to "tcqj"
  " - `grepprg` uses the -H and -I flags for regular grep, and defaults to using ripgrep if available
  if executable('rg')
    set grepprg=rg\ --vimgrep\ --uu
    set grepformat=%f:%l:%c:%m
  else
    set grepprg=grep\ -HIn\ $*\ /dev/null
  endif

  " - `hidden` is enabled
  " - `history` defaults to 10000 (the maximum)
  " - `hlsearch` is enabled
  " - `include` defaults to "". The C ftplugin sets it to "^\\s*#\\s*include"
  " - `incsearch` is enabled
  " - `isfname` does not include ":" (on Windows).
  " - `joinspaces` is disabled
  " - `jumpoptions` defaults to "clean"
  " - `langnoremap` is enabled
  " - `langremap` is disabled
  " - `laststatus` defaults to 2 (statusline is always shown)
  " - `listchars` defaults to "tab:> ,trail:-,nbsp:+"
  " - `maxsearchcount` defaults to 999
  " - `mouse` defaults to "nvi"
  " - `mousemodel` defaults to "popup_setpos"
  " - `nrformats` defaults to "bin,hex"
  " - `path` defaults to ".,,". The C ftplugin adds "/usr/include" if it exists.
  " - `sessionoptions` includes "unix,slash", excludes "options"
  " - `shortmess` includes "CF", excludes "S" TODO: test these!
  " - `sidescroll` defaults to 1
  " - `smarttab` is enabled
  " - `startofline` is disabled XXX: verify
  " - `switchbuf` defaults to "uselast XXX: verify
  " - `tabpagemax` defaults to 50
  " - `tags` defaults to "./tags;,tags"
  " - `termguicolors` is enabled by default if Nvim can detect support from the host terminal
  " - `ttimeout` is enabled
  " - `ttimeoutlen` defaults to 50
  " - `ttyfast` is always set
  " - `undodir` defaults to ~/.local/state/nvim/undo// (|xdg|), auto-created
  " - `viewoptions` includes "unix,slash", excludes "options"
  " - `viminfo` includes "!"
  " - `wildoptions` defaults to "pum,tagfile"
  set wildoptions=pum,tagfile

  " not needed with neovim's new default `'autoread'`
  " automatically reload files that have been changed outside of Vim
  " au FocusGained * if &buftype !=# 'nofile' | checktime | endif

endfunction
" https://github.com/tpope/vim-sensible
" also see `:h defaults.vim` and `$VIMRUNTIME/defaults.vim`
function! vimrc#sensible() abort
  set autoread
  set backspace=indent,eol,start
  set complete-=i
  set display+=lastline
  set formatoptions+=j
  set incsearch
  set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+
  set nrformats-=octal
  set smarttab

  " Persist g:UPPERCASE variables, used by some plugins, in .viminfo.
  if !empty(&viminfo)
    set viminfo^=!
  endif

  set nolangremap " Disable a legacy behavior that can break plugin maps.

  " Replace the check for a tags file in the parent directory of the current
  " file with a check in every ancestor directory.
  if has('path_extra') && (',' . &g:tags . ',') =~# ',\./tags,'
    setglobal tags-=./tags tags-=./tags; tags^=./tags;
  endif

  " clear the highlighting of 'hlsearch' (off by default) and call :diffupdate.
  nnoremap <silent> <C-L> :nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><C-L>

  " |i_CTRL-U-default| and |i_CTRL-W-default| set undo points
  inoremap <C-U> <C-G>u<C-U>
  inoremap <C-W> <C-G>u<C-W>

  " Load matchit.vim, but only if the user hasn't installed a newer version.
  if !exists('g:loaded_matchit') && findfile('plugin/matchit.vim', &rtp) ==# ''
    runtime! macros/matchit.vim
  endif

  " Enable the :Man command shipped inside Vim's man filetype plugin.
  if exists(':Man') != 2 && !exists('g:loaded_man') && &filetype !=? 'man' && !has('nvim')
    runtime ftplugin/man.vim
  endif

  " if has('vim_starting')
  if !(exists('g:did_load_filetypes')
	\ && exists('g:did_load_ftplugin')
	\ && exists('g:did_indent_on')
	\ )
    filetype plugin indent on
  endif
  if has('syntax') && !exists('g:syntax_on')
    syntax enable
  endif
endfunction
" vim: fdl=0 foldminlines=10
