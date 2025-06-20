function! fold#text()
  let s:foldchar = '—'
  let line1 = getline(v:foldstart)
  let indent = matchstr(line1, '^\s*')
  if line1 =~ '^\s*{'
    let next = getline(v:foldstart + 1)
    let line = indent . substitute(next, '^\s*', '{ ', '')
  else
    let line = substitute(line1, '\s*"\?\s*{{{\d*\s*$', '', '')
  endif
  let lines_count = v:foldend - v:foldstart + 1
  let lines_count_text = '|' . printf("%10s", lines_count . ' lines') . ' |'
  let pre = line
  let post = lines_count_text
  let width = 80
  let fill = repeat(s:foldchar, max([0, width - strdisplaywidth(pre . post)]))
  return pre . fill . post
endfunction
