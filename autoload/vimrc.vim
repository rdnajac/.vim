" let g:vimrc#dir = split(&runtimepath, ',')[0]
let g:vimrc#dir = fnamemodify($MYVIMRC, ':h')
let $VIMDIR = g:vimrc#dir

function! vimrc#init() abort
  if !has('nvim')
    call vim#defaults#()
    call vim#sensible#()
    " handle wrapped lines better by preferring `gj` and `gk`
    let s:keys = [ 'j', 'k' , '<Down>', '<Up>']
    for [i, key] in items(s:keys)
      let dir = s:keys[i % 2] " limit dir to only j/k
      execute printf("nnoremap <expr> %s v:count ? '%s' : 'g%s'", key, dir, dir)
      execute printf("xnoremap <expr> %s v:count ? '%s' : 'g%s'", key, dir, dir)
    endfor
    unlet s:keys
  else
    let g:loaded_node_provider = 0
    let g:loaded_perl_provider = 0
    let g:loaded_python3_provider = 0
    let g:loaded_ruby_provider = 0
  endif
endfunction

function! s:setmark(pattern, idx, line) abort
  let char = matchstr(a:line, a:pattern . '\zs.')
  if char !=# ''
    call setpos("'" . toupper(char), [0, a:idx + 1, 1, 0])
  endif
  return 0
endfunction

function! vimrc#setmarks() abort
  call map(getline(1, '$'), {idx, line -> s:setmark('augroup\ vimrc\.', idx, line)})
endfunction

function! vimrc#apathy(...) abort
  let orig = getbufvar('', '&path')
  let new = list#join(list#uniq(call('list#split', a:000 + [orig])))
  " let new = list#prepend(orig, a:000)
  call setbufvar('', '&path', new)
  return new
endfunction
