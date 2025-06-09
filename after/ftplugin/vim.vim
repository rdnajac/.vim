" cnoreabbrev <expr> L getcmdtype() == ':' && getcmdline() ==# 'L' ? '<c-r><c-l>' : 'L'

" better format automatic foldmarkers with `zf`
setlocal commentstring=\ \"\ %s
setlocal foldmethod=marker
setlocal iskeyword-=#

function! L() abort
  let l:line = getline('.')
  " if ft is lua, prepend lua
  if &ft ==# 'lua'
    let l:line = 'lua ' . l:line
  endif
  execute line
  echom line
endfunction

command! L call L()
" TODO isolate all CR mappings
nnoremap <buffer> <silent> <CR> :L<CR>
nnoremap <buffer> <silent> <M-CR> :source %<CR>

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
