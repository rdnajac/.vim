function! vimrc#init_vim() abort
  call vim#defaults#()
  call vim#sensible#()
  call vimrc#toggles()
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

function! vimrc#toggles() abort
  nnoremap yol :set list!<BAR>set list?<CR>
  nnoremap yon :set number!<BAR>redraw!<BAR>set number?<CR>
  nnoremap yos :set spell!<BAR>set spell?<CR>
  nnoremap yow :set wrap!<BAR>set wrap?<CR>
  nnoremap yo~ :set autochdir!<BAR>set autochdir?<CR>
endfunction

" `apathy#Prepend()` but only for path
function! vimrc#apathy(...) abort
  let orig = getbufvar('', '&path')
  let val = list#join(list#uniq(call('list#split', a:000 + [orig])))
  call setbufvar('', '&path', val)
  return val
endfunction

