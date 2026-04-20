if !exists('g:speeddating_handlers')
  finish
endif

function! s:dial(words, string, offset, increment) abort
  let idx = index(a:words, a:string)
  return idx < 0 ? ['', -1] : [a:words[max([0, min([len(a:words) - 1, idx + a:increment])])], -1]
endfunction

" handle negative modulo correctly
function! s:mod(idx, size) abort
  let r = a:idx % a:size
  return r < 0 ? r + a:size : r
endfunction

function! s:cycle(words, string, offset, increment) abort
  let idx = index(a:words, a:string)
  return idx < 0 ? ['', -1] : [a:words[s:mod(idx + a:increment, len(a:words))], -1]
endfunction

function! s:new_dial(words, ...) abort
  let pattern = a:0 ? a:1 : '\<'..join(copy(a:words), '\>\|\<')..'\>'
  let Dial = {string, offset, increment -> s:cycle(a:words, string, offset, increment)}
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
      \ ['echom', 'execute'],
      \ ])
  call s:new_dial(series)
endfor

" let s:md_headers = map(range(1, 6), 'repeat("#", v:val)')
let s:md_headers = map(range(1, 6), {_, v -> repeat('#', v)})

call s:new_dial(s:md_headers, '^#*\ze\(\s\|$\)')

let s:lua_require_pattern = 'require(\([''"]\)\(\k\+\%(\.\k\+\)*\)\1)\(\%(\.\k\+\)*\)'
" single quotes only
let s:lua_require_single = 'require('.."'"..'\(\k\+\%(\.\k\+\)*\)'.."'"..')'..'\(\%(\.\k\+\)*\)'

function! s:lua_require(string, offset, increment) abort
  let captures = matchlist(a:string, '^'..s:lua_require_single..'$')
  if !empty(captures)
    let modules = split(captures[1], '\.')
    let parts = modules + (empty(captures[2]) ? [] : split(captures[2][1:], '\.'))
    let new_idx = s:mod(len(modules) - 1 + a:increment, len(parts))
    let ret = printf("require('%s')", join(parts[:new_idx], '.'))
    if new_idx + 1 < len(parts)
      let ret = join([ret] + parts[new_idx + 1:], '.')
    endif
    return [ret, -1]
  endif
  return ['', -1]
endfunction
let g:speeddating_handlers += [{'regexp': s:lua_require_single, 'increment': function('s:lua_require')}]
