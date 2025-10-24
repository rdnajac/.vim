" execute a function on VimEnter or immediately if did enter
function! vimrc#onVimEnter(fn) abort
  if v:vim_did_enter
    call call(a:fn, [])
  else
    execute 'autocmd VimEnter * call ' . string(a:fn) . '()'
  endif
endfunction

function! vimrc#init_vim() abort
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

function! vimrc#setmarks() abort
  for l:num in range(1, line('$'))
    if getline(l:num) =~? '^"\s*Section:\s*\zs.'
      let l:char = matchstr(getline(l:num), '^"\s*Section:\s*\zs.')
      call setpos("'" . toupper(l:char), [0, l:num, 1, 0])
    endif
  endfor
endfunction
