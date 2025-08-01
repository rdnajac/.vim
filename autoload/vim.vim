function! vim#home() abort
  return has('nvim') ? stdpath('config') : split(&rtp, ',')[0]
endfunction

" configure vim-specific settings
function! vim#rc() abort
  let l:home = vim#home()
  let &viminfofile = home . '.viminfo'
  let &verbosefile = home . '.vimlog.txt'

  color scheme

  " some settings are already default in nvim
  set autoread
  set wildoptions=pum,tagfile

  " use ripgrep for searching
  if executable('rg')
    set grepprg=rg\ --vimgrep\ --uu
    set grepformat=%f:%l:%c:%m
  endif
endfunction

function! vim#nvim_init() abort
  set backup
  set backupext=.bak
  let &backupdir = stdpath('state') . '/backup//'
  let &backupskip .= ',' . escape(expand('$HOME/.cache/*'), '\')
  let &backupskip .= ',' . escape(expand('$HOME/.local/*'), '\')
  set undofile

  " don't use the clipboard over ssh
  if !exists('$SSH_TTY')
    set clipboard=unnamedplus
  endif

  " nvim-specific settings
  set jumpoptions+=view
  set mousescroll=hor:0
  set smoothscroll

  " disable the default popup menu
  aunmenu PopUp | autocmd! nvim.popupmenu
endfunction
