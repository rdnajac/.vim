  function! s:singlequote(str)
    return "'"..substitute(copy(a:str), "'", "''", 'g').."'"
  endfunction

  " maybe check getcmdline() =~# "%s"

  " a robust way to create cmdline abbreviations
  function! cmd#abbrev(lhs, rhs)
    execute printf(
	  \ 'cabbrev <expr> %s (getcmdtype() == ":" && getcmdpos() <= %d) ? %s : %s',
	  \ a:lhs, 1+len(a:lhs), s:singlequote(a:rhs), s:singlequote(a:lhs))
  endfunction
