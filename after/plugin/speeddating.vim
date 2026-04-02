" Generic function to add word switches (cycles through list)
function! s:new_dial(words) abort
  " Build regex pattern
  let pattern = printf('\<\%%(%s\)\>', join(map(copy(a:words), 'escape(v:val, "\\.*^$[]")'), '\|'))
  let Toggle = {string, offset, increment -> s:toggle_words(a:words, string, offset, increment)}

  let g:speeddating_handlers += [
	\ {'regexp': pattern,
	\  'increment': Toggle}
	\ ]
endfunction

function! s:toggle_words(words, string, offset, increment) abort
  let index = index(a:words, a:string)

  if index >= 0
    let len = len(a:words)
    let new_index = (index + a:increment) % len
    if new_index < 0 " handle negative modulo
      let new_index = new_index + len
    endif
    return [a:words[new_index], -1]
  endif

  return ['', -1]
endfunction

call s:new_dial(['true', 'false'])
call s:new_dial(['True', 'False'])
call s:new_dial(['TRUE', 'FALSE'])
call s:new_dial(['start', 'end'])
call s:new_dial(['row', 'col'])
call s:new_dial(['human', 'mouse'])
