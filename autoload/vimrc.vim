""
" @section Introduction, intro
" @stylized rdnajac/.vim
" @library
" @order intro version
" A vimscript library that hides the worst parts of vimscript and helps you
" provide consistent plugins.
"

function! vimrc#init() abort
  execute 'call vimrc#init_' . (has('nvim') ? 'n' : '') . 'vim()'
endfunction

function! vimrc#home() abort
  return has('nvim') ? stdpath('config') : split(&runtimepath, ',')[0]
endfunction

""
" configure vim-specific settings (these are only run once)
function! vimrc#init_vim() abort " {{{
  let l:home = vimrc#home()
  let &viminfofile = home . '.viminfo'
  let &verbosefile = home . '.vimlog.txt'

  " some settings are already default in nvim
  set wildoptions=pum,tagfile

  " use ripgrep for searching
  if executable('rg')
    set grepprg=rg\ --vimgrep\ --uu
    set grepformat=%f:%l:%c:%m
  endif

  call vim#sensible#()
  call vim#toggle#()
  color scheme " set the default colorscheme once
endfunction

" }}}
function! vimrc#nvim_config() abort " {{{
  set backup
  set backupext=.bak
  let &backupdir = stdpath('state') . '/backup//'
  let &backupskip .= ',' . escape(expand('$HOME/.cache/*'), '\')
  let &backupskip .= ',' . escape(expand('$HOME/.local/*'), '\')
  set undofile

  " nvim-specific settings
  set pumblend=0
  set smoothscroll
  set jumpoptions+=view
  set mousescroll=hor:0
  set nocdhome
  " NOTE: also try running `:options`

  " disable the default popup menu
  aunmenu PopUp | autocmd! nvim.popupmenu

  " -- initialize tabline
  call vimline#tabline#()

  let g:nvim_did_init = v:true
endfunction

" }}}
function! vimrc#init_nvim() abort " {{{
  if !exists('g:nvim_did_init')
    let g:nvim_did_init = v:false
    " PERF: set theset right away as _extui depends on them
    set cmdheight=0
    set winborder=rounded
    call vimrc#on_init(function('vimrc#nvim_config'))
  endif
endfunction

" }}}
""
" execute a function on VimEnter or immediately if already entered
function! vimrc#on_init(fn) abort " {{{
  if v:vim_did_enter
    call call(a:fn, [])
  else
    execute 'autocmd VimEnter * call ' . string(a:fn) . '()'
  endif
endfunction

" }}}
