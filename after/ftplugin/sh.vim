if !exists('g:shellharden')
  let g:shellharden = 1
endif

if executable('shfmt')
  let &l:formatprg = 'shfmt -bn -sr'
  if executable('shellharden')
    " pipe the formatprg output to shellharden if shellharden is enabled
    if get(b:, 'shellharden', get(g:, 'shellharden', 0))
      let &l:formatprg .= ' | shellharden --transform ""'
    endif
  endif
endif

if has('nvim')
  lua vim.treesitter.start()
endif
