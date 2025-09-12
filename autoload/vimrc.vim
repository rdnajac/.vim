""
" @section Introduction, intro
" @stylized rdnajac/.vim
" @library
" @order intro version
" A vimscript library that hides the worst parts of vimscript and helps you
" provide consistent plugins.
"

""
" execute a function on VimEnter or immediately if already entered
function! vimrc#on_init(fn) abort
  if v:vim_did_enter
    call call(a:fn, [])
  else
    execute 'autocmd VimEnter * call ' . string(a:fn) . '()'
  endif
endfunction

function! vimrc#home() abort
  return has('nvim') ? stdpath('config') : split(&runtimepath, ',')[0]
endfunction

function! vimrc#init() abort
  execute 'call vimrc#init_' . (has('nvim') ? 'n' : '') . 'vim()'
endfunction

""
" configure vim-specific settings
" these are only run once
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
  set jumpoptions+=view
  set mousescroll=hor:0
  set nocdhome
  " NOTE: ui options are set earlier  on in `init.lua`
  " NOTE: also try `:options`

  " disable the default popup menu
  aunmenu PopUp | autocmd! nvim.popupmenu

  let g:nvim_did_init = 1
endfunction

" }}}
function! vimrc#init_nvim() abort
  if !exists('g:nvim_did_init')
    " Disable external providers
    let g:loaded_node_provider = 0
    let g:loaded_perl_provider = 0
    let g:loaded_ruby_provider = 0

    " ---@type 'netrw'|'snacks'|'oil'
    let g:file_explorer = 'oil'

    " disable netrw if using a different file explorer
    if exists('g:file_explorer') && g:file_explorer !=# 'netrw'
      " let g:loaded_netrwPlugin = 1
      let g:loaded_netrw = 1
    endif

    call vimrc#on_init(function('vimrc#nvim_config'))
  endif
endfunction

" TODO: template function to create or increment global variable
