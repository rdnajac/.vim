if executable('ruff')
  let &l:formatprg = 'ruff format -q --stdin-filename ' . expand('%:p') . ' -'
endif
