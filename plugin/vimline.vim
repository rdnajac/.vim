let &laststatus = has('nvim') ? 3 : 2
set statusline=%!vimline#statusline()

if has('nvim')
  set winbar=%{%v:lua.nv.winbar()%}
endif
