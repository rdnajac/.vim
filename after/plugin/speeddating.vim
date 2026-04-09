function! s:dial(words, string, offset, increment, cyclic) abort
  let index = index(a:words, a:string)
  if index >= 0
    let len = len(a:words)
    if a:cyclic
      let new_index = (index + a:increment) % len
      if new_index < 0 " handle negative modulo
	let new_index = new_index + len
      endif
    else
      let new_index = index + a:increment
      let new_index = max([0, min([len - 1, new_index])])
    endif
    return [a:words[new_index], -1]
  endif
  return ['', -1]
endfunction

function! s:new_dial(words, ...) abort
  let pattern = a:0 ? a:1 : printf('\<%s\>', join(copy(a:words), '\>\|\<'))
  " \ join(map(copy(a:words), {_, word -> escape(word, '\.*^$[]')}), '\>\|\<'))

  let Dial = {string, offset, increment -> s:dial(a:words, string, offset, increment, 1)}

  let g:speeddating_handlers += [{'regexp': pattern, 'increment': Dial}]
endfunction

for series in ([
      \ ['true', 'false'],
      \ ['True', 'False'],
      \ ['TRUE', 'FALSE'],
      \ ['start', 'end'],
      \ ['row', 'col'],
      \ ['up', 'down'],
      \ ['left', 'right'],
      \ ['top', 'middle', 'bottom'],
      \ ])
  call s:new_dial(series)
endfor

call s:new_dial ([ 'echom', 'execute' ]) " TODO: vim only

let s:md_headers = map(range(1, 6), 'repeat("#", v:val)')
" let s:md_headers = map(range(1, 6), {v -> repeat('#', v)})
call s:new_dial(s:md_headers, '^#*\ze\(\s\|$\)')

" TODO: add lua-require dial
