scriptencoding utf-8 " Use scriptencoding when multibyte char exists

function! vim#chars#fillchars() abort
  set fillchars= " reset
  " set fillchars+=diff:╱
  " set fillchars+=eob:,
  " set fillchars+=stl:\ ,

  " folding
  set fillchars+=fold:\ ,
  set fillchars+=foldclose:▸,
  set fillchars+=foldopen:▾,
  " set fillchars+=foldsep:\ ,
endfunction

function! vim#chars#listchars() abort
  set listchars= " reset
  set listchars+=trail:¿,
  set listchars+=tab:→\ ",
  set listchars+=extends:…,
  set listchars+=precedes:…,
  set listchars+=nbsp:+
endfunction

" insert special chars
iabbrev n- –
iabbrev m- —
