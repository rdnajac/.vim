" https://www.vim.org/scripts/script.php?script_id=1876
" https://github.com/numirias/security/blob/master/doc/2019-06-04_ace-vim-neovim.md
let g:secure_modelines_modelines = 1
let g:secure_modelines_allowed_items = [
      \ 'textwidth',   'tw',
      \ 'softtabstop', 'sts',
      \ 'tabstop',     'ts',
      \ 'shiftwidth',  'sw',
      \ 'expandtab',   'et',   'noexpandtab', 'noet',
      \ 'filetype',    'ft',
      \ 'foldmethod',  'fdm',
      \ 'foldlevel',   'fdl',
      \ 'readonly',    'ro',   'noreadonly',  'noro',
      \ 'rightleft',   'rl',   'norightleft', 'norl',
      \ 'spell',       'nospell', 'spelllang',
      \ 'wrap',        'nowrap',
      \ ]

function! s:DoOne(item) abort
  let l:matches = matchlist(a:item, '^\([a-z]\+\)\%([-+^]\?=[a-zA-Z0-9_\-,.]\+\)\?$')
  if len(l:matches) > 0
    if index(g:secure_modelines_allowed_items, l:matches[1]) != -1
      exec 'setlocal ' . a:item
    else
      echohl WarningMsg
      echo "Ignoring '" . a:item . "' in modeline"
      echohl None
    endif
  endif
endfun

function! s:DoSetModeline(line) abort
  for l:item in split(a:line)
    call s:DoOne(l:item)
  endfor
endfun

function! s:DoNoSetModeline(line) abort
  for l:item in split(a:line, '[ \t:]')
    call s:DoOne(l:item)
  endfor
endfun

function! s:DoModeline(line) abort
  let l:matches = matchlist(a:line, '\(vi\|vim\|ex\):\s*\%(set\s\+\)\?\([^:]\+\):')
  if len(l:matches) > 0
    return s:DoSetModeline(l:matches[2])
  endif
  let l:matches = matchlist(a:line, '\(vi\|vim\|ex\):\(.\+\)')
  if len(l:matches) > 0
    return s:DoNoSetModeline(l:matches[2])
  endif
endfun

function! s:DoModelines() abort
  for l:line in getline(1, '$')
    call s:DoModeline(l:line)
  endfor
endfun

augroup SecureModeLines
  autocmd!
  autocmd BufRead,StdinReadPost * :call s:DoModelines()
augroup END
