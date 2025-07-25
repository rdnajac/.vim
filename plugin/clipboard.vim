finish
" BUG: this checks before the deferred loading, so it always executes
if &clipboard == ''
  nnoremap y "+y
  vnoremap y "+y
endif
