" TODO: rewrite for dirvish? vim.buf?
if expand('%:p') =~# '/.local/state/nvim/backup/'
  " Show / for slashes
  syn match oilSlash /%/ conceal cchar=/
  " hide .bak extension
  syn match oilBak /.bak/ conceal
endif
