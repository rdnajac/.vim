" autoload/vim/mode.vim

" TODO: link to highlight group
let s:ModeColor = {
      \ 'normal':   '#9ECE6A',
      \ 'insert':   '#39FF14',
      \ 'visual':   '#F7768E',
      \ 'select':   '#FF9E64',
      \ 'replace':  '#FF007C',
      \ 'command':  '#E0AF68',
      \ 'terminal': '#BB9AF7',
      \ 'pending':  '#FFFFFF',
      \ 'shell':    '#14AEFF',
      \ }

function! vim#mode#(...) abort
  let m = a:0 ? a:1 : mode(1)

  " Detect true operator-pending only if we're still waiting
  " if m =~# '^no' && getchar(1)
  if m =~# '^no' && getchar(1) == 0
    return 'pending'
  elseif m[0] ==# 'n'
    return 'normal'
  elseif m[0] ==? 'v' || m =~# ''
    return 'visual'
  elseif m[0] ==? 's'|| m =~# '^\<C-S>'
    return 'select'
  elseif m[0] ==# 'i'
    return 'insert'
  elseif m[0] ==# 'R'
    return 'replace'
  elseif m[0] ==# 'c' || m[0] ==# 'r'
    return 'command'
  elseif m[0] ==# 't'
    return 'terminal'
  elseif m[0] ==# '!'
    return 'shell'
  endif

  return 'normal'
endfunction

function! vim#mode#color() abort
  return get(s:ModeColor, vim#mode#(), s:ModeColor.normal)
endfunction
