" execute a function on VimEnter or immediately if did enter
function! vimrc#onVimEnter(fn) abort " {{{
  if v:vim_did_enter
    call call(a:fn, [])
  else
    execute 'autocmd VimEnter * call ' . string(a:fn) . '()'
  endif
endfunction

" }}}
function! vimrc#init_vim() abort " {{{
  let &viminfofile = g:vimrc#home . '.viminfo'
  let &verbosefile = g:vimrc#home . '.vimlog.txt'

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

  " BUG: still does not work with the version of vim on homebrew
  " VIM - Vi IMproved 9.1 (2024 Jan 02, compiled Oct 12 2025 14:37:02)
  " macOS version - arm64
  " Included patches: 1-1850
  packadd comment
  " see `:h package-comment`
  " issue: https://github.com/vim/vim/issues/14171
  " commit: https://github.com/vim/vim/commit/fa6300872732f80b770a768e785ae2b189d3e684
  " suspect: import autoload 'comment.vim'
  " HACK: this works...?
  source $VIMRUNTIME/pack/dist/opt/comment/autoload/comment.vim
endfunction

" }}}
function! vimrc#init_nvim() abort " {{{
  if !exists('g:nvim_did_init')
    let g:nvim_did_init = v:false
    packadd! nvim.difftool
    packadd! nvim.undotree
    call vimrc#onVimEnter(function('vimrc#nvim_config'))
  endif
endfunction

" }}}
function! vimrc#nvim_config() abort " {{{
  set backup
  set backupext=.bak
  let &backupdir = g:stdpath['state'] . '/backup//'
  let &backupskip .= ',' . escape(expand('$HOME/.cache/*'), '\')
  let &backupskip .= ',' . escape(expand('$HOME/.local/*'), '\')
  set undofile

  " nvim-specific settings
  " try running `:options`
  set smoothscroll
  set jumpoptions+=view
  set mousescroll=hor:0
  set nocdhome

  " disable the default popup menu
  aunmenu PopUp | autocmd! nvim.popupmenu

  let g:nvim_did_init = v:true
endfunction

" }}}

function! vimrc#autosection() abort " {{{
  for l:line in readfile(g:my#vimrc)
    if l:line =~? '^"\s*Section:\s*'
      let l:idx = matchend(l:line, '^"\s*Section:\s*')
      let l:ch  = strcharpart(l:line, l:idx, 1)
      execute printf("nnoremap <silent> <leader>v%s :call edit#vimrc('\+\/Section:\\ %s')<CR>", l:ch, l:ch)
    endif
  endfor
endfunction

" }}}
