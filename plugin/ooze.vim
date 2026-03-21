if !has('nvim')
  finish
endif
let g:loaded_ooze = 1

if !exists('g:ooze_auto_advance')  | let g:ooze_auto_advance  = 1 | endif
if !exists('g:ooze_auto_scroll')   | let g:ooze_auto_scroll   = 1 | endif
if !exists('g:ooze_auto_exec')     | let g:ooze_auto_exec     = 1 | endif
if !exists('g:ooze_skip_comments') | let g:ooze_skip_comments = 1 | endif
if !exists('g:ooze_cr') | let g:ooze_cr = 1 | endif

" nnoremap <leader><CR> <Cmd>call ooze#init()<CR>
" nnoremap <M-CR> <Cmd>call ooze#file()<CR>
" nnoremap <expr> <CR> ooze#line() > 0 ? '' : "\<CR>"

augroup ooze
  autocmd!
  autocmd TermOpen * let g:ooze_channel = &channel
  autocmd TermOpen * let g:ooze_buffer = bufnr('%')
  " autocmd Filetype vim,lua nnoremap <buffer> <CR> <Cmd>call CRooze()<CR>
  " autocmd Filetype r,rmd nnoremap <buffer> <CR> <Cmd>call ooze#send(getline('.'))<CR>
  " autocmd Filetype vim,lua nnoremap <buffer> <CR> <Cmd>call ooze#send()<CR>
  " autocmd TermClose * unlet! g:ooze_channel
augroup END

function! Append(...) abort
  if a:0 > 0
    " Called with args: :Append echo "hello"
    let cmd = join(a:000, ' ')
  else
    " Called from cmdline mapping
    let cmd = getcmdline()
    if empty(cmd) || getcmdtype() != ':'
      return '<M-CR>'
    endif
    call feedkeys("\<C-c>", 'n')
    call timer_start(0, {-> Append(cmd)})
    return ''
  endif
  let output = execute(cmd)
  let lines = split(output, "\n", 1)
  while !empty(lines) && empty(lines[0])
    call remove(lines, 0)
  endwhile
  if !empty(lines)
    call append('$', lines)
  endif
endfunction

command! -nargs=+ Append call Append(<q-args>)
cnoremap <expr> <M-CR> Append()
