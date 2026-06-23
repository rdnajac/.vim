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

function! s:visual_selection() abort
  return getregion(getpos("'<"), getpos("'>"), #{ type: visualmode() })
endfunction

function! hyperlink#() range abort
  let [lnum1, col1] = getpos("'<")[1 : 2]
  let [lnum2, col2] = getpos("'>")[1 : 2]
  let line = getline(lnum1)
  let selection = join(s:visual_selection(), "\n")

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
