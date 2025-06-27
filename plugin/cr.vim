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

function! s:SourceMsg() abort
  execute 'source %'
  echom expand('%') . ' sourced!'
endfunction

augroup MapCR
  autocmd!
  autocmd FileType vim,lua nnoremap <buffer> <silent> <CR> <CMD>call <SID>L()<CR>
  autocmd FileType vim,lua nnoremap <buffer> <silent> <M-CR> <CMD>call <SID>SourceMsg()<CR>
augroup END
