let &laststatus = has('nvim') ? 3 : 2
set statusline=%!vimline#statusline()

lua vim.schedule(function() vim.cmd([[set winbar=%{%v:lua.nv.winbar()%}]]) end)
