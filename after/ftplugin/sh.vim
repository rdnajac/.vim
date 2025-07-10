if executable('shfmt')
  if !exists('g:shellharden')
    let g:shellharden = 1
  endif

  if !exists('g:sh_simple')
    let g:sh_simple = 1
  endif

  let s:cmd = 'shfmt -bn -sr'
  if get(b:, 'sh_simple', get(g:, 'sh_simple', 0))
    let s:cmd .= ' --simplify'
  endif
  if executable('shellharden') && get(b:, 'shellharden', get(g:, 'shellharden', 0))
    let s:cmd = 'shellharden --transform "" | ' . s:cmd
  endif

  let &l:formatprg = s:cmd
endif
