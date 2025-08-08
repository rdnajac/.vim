function! vim#home() abort
  return has('nvim') ? stdpath('config') : split(&rtp, ',')[0]
endfunction

function! vim#rc() abort
  execute 'call vim#' . (has('nvim') ? 'n' : '') . 'vim_init()'
endfunction

" configure vim-specific settings
function! vim#vim_init() abort
  let l:home = vim#home()
  let &viminfofile = home . '.viminfo'
  let &verbosefile = home . '.vimlog.txt'

  " some settings are already default in nvim
  set wildoptions=pum,tagfile

  " use ripgrep for searching
  if executable('rg')
    set grepprg=rg\ --vimgrep\ --uu
    set grepformat=%f:%l:%c:%m
  endif

  call vim#sensible#setup()
endfunction

function! s:init() abort
  set backup
  set backupext=.bak
  let &backupdir = stdpath('state') . '/backup//'
  let &backupskip .= ',' . escape(expand('$HOME/.cache/*'), '\')
  let &backupskip .= ',' . escape(expand('$HOME/.local/*'), '\')
  set undofile

  " nvim-specific settings
  set jumpoptions+=view
  set mousescroll=hor:0
  set nocdhome
  set smoothscroll

  " disable the default popup menu
  aunmenu PopUp | autocmd! nvim.popupmenu
endfunction

function! vim#nvim_init() abort
  if v:vim_did_enter
    call s:init()
  else
    augroup nvim_init
      autocmd!
      autocmd VimEnter * call s:init()
    augroup END
  endif
endfunction
