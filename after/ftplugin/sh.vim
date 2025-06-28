if !exists('g:shellharden')
  let g:shellharden = 1
endif

if !exists('g:sh_simple')
  let g:sh_simple = 1
endif

if executable('shfmt')
  let &l:formatprg = 'shfmt -bn -sr'
  if executable('shellharden') && get(b:, 'shellharden', get(g:, 'shellharden', 0))
    let &l:formatprg .= ' | shellharden --transform ""'
    if get(b:, 'sh_simple', get(g:, 'sh_simple', 0))
      let &l:formatprg .= ' | shfmt --simplify'
    endif
  elseif get(b:, 'sh_simple', get(g:, 'sh_simple', 0))
    let &l:formatprg .= ' --simplify'
  endif
endif

if has('nvim')
  lua vim.treesitter.start()
endif
