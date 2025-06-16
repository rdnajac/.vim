function! fold#text()
  let s:foldchar = '—'
  let line = substitute(getline(v:foldstart), '^\s*"\?\s*\|\s*"\?\s*{{{\d*\s*', '', 'g') . ' ' . s:foldchar
  let lines_count = v:foldend - v:foldstart + 1
  let lines_count_text = '|' . printf("%10s", lines_count . ' lines') . ' |'
  let foldtextstart = strpart(repeat(s:foldchar, v:foldlevel * 2) . ' ' . line, 0, (winwidth(0) * 2) / 3)
  let foldtextend = lines_count_text . repeat(s:foldchar, 8)
  let foldtextlength = strlen(substitute(foldtextstart . foldtextend, '.', 'x', 'g')) + &foldcolumn
  return foldtextstart . repeat(s:foldchar, winwidth(0) - foldtextlength) . foldtextend
endfunction
