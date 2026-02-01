let g:vimrc#dir = split(&runtimepath, ',')[0]

function! s:on_enter(fn) abort
  if v:vim_did_enter
    call call(a:fn, [])
  else
    execute 'autocmd VimEnter * call ' . string(a:fn) . '()'
  endif
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

" like `apathy#Prepend()` but only for path
function! vimrc#apathy(...) abort
  let orig = getbufvar('', '&path')
  let val = list#join(list#uniq(call('list#split', a:000 + [orig])))
  call setbufvar('', '&path', val)
  return val
endfunction
