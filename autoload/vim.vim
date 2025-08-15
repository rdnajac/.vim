function! vim#on_init(fn) abort
  if v:vim_did_enter
    call call(a:fn, [])
  else
    execute 'autocmd VimEnter * call call(function(' . string(a:fn) . '), [])'
  endif
endfunction

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

function! vim#nvim_config() abort
  set backup
  set backupext=.bak
  let &backupdir = stdpath('state') . '/backup//'
  let &backupskip .= ',' . escape(expand('$HOME/.cache/*'), '\')
  let &backupskip .= ',' . escape(expand('$HOME/.local/*'), '\')
  set undofile

  " nvim-specific settings
  " NOTE: ui options are set earlier  on in `init.lua`
  set jumpoptions+=view
  set mousescroll=hor:0
  set nocdhome
  set smoothscroll

  " disable the default popup menu
  aunmenu PopUp | autocmd! nvim.popupmenu

  if !exists('g:nvim_init_count')
    let g:nvim_init_count = 0
  else
    let g:nvim_init_count += 1
    let msg = 'Reloaded vimrc [' . g:vimrc_reload_count . ']'
    call vim#notify#info(msg)
  endif
endfunction

function! vim#nvim_init() abort
  call vim#on_init(function('vim#nvim_config'))
endfunction
