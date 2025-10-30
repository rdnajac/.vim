" TODO: get MiniSurround to do the same thing

function! s:sanitize(str) abort
  let s = a:str
  if s ==# '' || type(s) != v:t_string
    let s = ''
  endif
  " Take only first line, replace multiple spaces, trim start/end
  let s = matchstr(s, '^[^\r\n]*')
  let s = substitute(s, '\s\+', ' ', 'g')
  let s = substitute(s, '^\s\+', '', '')
  let s = substitute(s, '\s\+$', '', '')
  return s
endfunction

function! hyperlink#() range abort
  " Exit select/visual mode
  "call feedkeys("\<Esc>", 'x')

  let start_pos = getpos("'<")
  let end_pos   = getpos("'>")

  let lnum1 = start_pos[1]
  let col1  = start_pos[2]
  let lnum2 = end_pos[1]
  let col2  = end_pos[2]

  let line = getline(lnum1)
  if lnum1 == lnum2
    let selection = strpart(line, col1 - 1, col2 - col1 + 1)
  else
    " Multi-line selection: take from start col to end col of last line
    let lines = getline(lnum1, lnum2)
    let lines[0] = strpart(lines[0], col1 - 1)
    let lines[-1] = strpart(lines[-1], 0, col2)
    let selection = join(lines, "\n")
  endif

  let is_url = selection =~? '^https\?://'

  if is_url
    let prompt = 'Link text: '
    let default_val = ''
  else
    let prompt = 'URL (default from clipboard): '
    let default_val = s:sanitize(getreg('+'))
  endif

  " Blocking input() since Vimscript has no async ui.input
  let input_val = input(prompt, default_val)

  if empty(input_val)
    return
  endif

  if is_url
    let text = input_val
    let url = selection
  else
    let text = selection
    let url = input_val
  endif

  let hyperlink = printf('[%s](%s)', s:sanitize(text), url)

  " Replace selection with hyperlink
  if lnum1 == lnum2
    let newline = strpart(line, 0, col1 - 1) . hyperlink . strpart(line, col2)
    call setline(lnum1, newline)
  else
    let new_lines = split(hyperlink, "\n")
    call setline(lnum1, new_lines)
    if lnum2 > lnum1
      call deletebufline('%', lnum1 + len(new_lines), lnum2)
    endif
  endif
endfunction

" test here!
" http://example.com
" some text
