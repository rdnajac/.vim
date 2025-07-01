function! s:execute_line() abort
  let l:line = getline('.')
  if &filetype ==# 'lua'
    let l:line = 'lua ' . l:line
  elseif &filetype !=# 'vim'
    echom l:line
    return
  endif
  execute l:line
  echom l:line
endfunction

function! s:source_file() abort
  execute 'source %'
  echom 'sourced `' . expand('%') . '`!'
endfunction

augroup MapCR
  autocmd!
  autocmd FileType vim,lua nnoremap <buffer> <silent> <CR> <CMD>call <SID>execute_line()<CR>
  autocmd FileType vim,lua nnoremap <buffer> <silent> <M-CR> <CMD>call <SID>source_file()<CR>
  autocmd FileType     lua nnoremap <buffer> <silent> <leader><CR> <CMD>lua Snacks.debug.run()<CR>
  autocmd FileType     lua vnoremap <buffer> <silent> <leader><CR> :lua Snacks.debug.run()<CR>
augroup END

" TODO: ooze send
