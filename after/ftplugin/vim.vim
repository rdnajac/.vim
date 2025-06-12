" cnoreabbrev <expr> L getcmdtype() == ':' && getcmdline() ==# 'L' ? '<c-r><c-l>' : 'L'

" better format automatic foldmarkers with `zf`
setlocal commentstring=\ \"\ %s
setlocal foldmethod=marker
setlocal iskeyword-=#

imap <M-Up> <Up>
imap <M-Down> <Down>
imap <M-Left> <Left>
imap <M-Right> <Right>

function MyFoldText() " {{{
  let line = getline(v:foldstart)
  let sub = substitute(line, '\s*{{{\d\=', '', '')
  " let text = v:folddashes .. sub
  let text = sub .. ' '
  let padlen = 80 - strwidth(text)
  if padlen > 0
    let text .= repeat('—', padlen)
  endif
  return text
endfunction
setlocal foldtext=MyFoldText() " }}}
