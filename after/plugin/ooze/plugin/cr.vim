" functions and mappings for the <CR> key

function! L() abort
  let l:line = getline('.')
  if &ft ==# 'lua'
    let l:line = 'lua ' . l:line
  elseif &ft !=# 'vim'
    " return <CR>
    echom line
  endif
  execute line
  echom line
endfunction

command! L call L()

augroup MapCR
  autocmd!
  autocmd FileType vim,lua nnoremap <buffer> <silent> <CR> <CMD>L<CR>
  autocmd FileType vim,lua nnoremap <buffer> <silent> <M-CR> <CMD>source %<CR>

augroup END
