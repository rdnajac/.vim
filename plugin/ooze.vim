if exists('g:loaded_ooze') || !has('nvim')
  finish
endif
let g:loaded_ooze = 1

if !exists('g:ooze_auto_advance')  | let g:ooze_auto_advance  = 1 | endif
if !exists('g:ooze_auto_scroll')   | let g:ooze_auto_scroll   = 1 | endif
if !exists('g:ooze_auto_exec')     | let g:ooze_auto_exec     = 1 | endif
if !exists('g:ooze_skip_comments') | let g:ooze_skip_comments = 1 | endif
if !exists('g:ooze_cr') | let g:ooze_cr = 1 | endif


function! CRooze() abort
  let l:ft = &filetype
  let l:line = getline('.')

  if l:ft ==# 'qf\|pager'
   return 0
  endif

  if l:line[0] ==# '#' && l:line[1] ==# '!'
    Info bang
    return 0
  endif

  if l:ft ==# 'vim' || l:ft ==# 'lua'
    " check if the line contains the word `function`
    " if it does, call ooze#fn that calls the function
    " see yankmkd for capturing and converting modnames
    execute (l:ft ==# 'lua' ? 'lua ' : '') . l:line
    Info (l:ft ==# 'lua' ? ' ' : ' ') . '[[' . l:line . ']]'
    return 1
  endif

  return ooze#send(l:line)
endfunction


" nnoremap <leader><CR> <Cmd>call ooze#init()<CR>
" nnoremap <M-CR> <Cmd>call ooze#file()<CR>
" nnoremap <expr> <CR> CRooze() > 0 ? '' : "\<CR>"

augroup ooze
  autocmd!
  autocmd TermOpen * let g:ooze_channel = &channel
  autocmd TermOpen * let g:ooze_buffer = bufnr('%')
  " TODO: move to R
  autocmd Filetype r,rmd,quarto nnoremap <buffer> <CR> <Plug>RDSendLine
  " autocmd Filetype vim,lua nnoremap <buffer> <CR> <Cmd>call CRooze()<CR>
  " autocmd Filetype r,rmd nnoremap <buffer> <CR> <Cmd>call ooze#send(getline('.'))<CR>
  " autocmd Filetype vim,lua nnoremap <buffer> <CR> <Cmd>call ooze#send()<CR>
  " autocmd TermClose * unlet! g:ooze_channel
augroup END
