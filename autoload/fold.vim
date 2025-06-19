function! fold#text()
  let s:foldchar = '—'
  let line = substitute(getline(v:foldstart), '\s*"\?\s*{{{\d*\s*$', '', '')
  let lines_count = v:foldend - v:foldstart + 1
  let lines_count_text = '|' . printf("%10s", lines_count . ' lines') . ' |'
  let pre = line
  let post = lines_count_text
  let width = 80
  let fill = repeat(s:foldchar, max([0, width - strdisplaywidth(pre . post)]))
  return pre . fill . post
endfunction
